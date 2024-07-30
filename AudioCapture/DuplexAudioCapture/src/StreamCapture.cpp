#include "pch.h"

#include <iostream>
#include <guiddef.h>
#include <mmdeviceapi.h>
#include <Windows.h>
#include <Audioclient.h>
#include "StreamCapture.h"
#include <wil/result_macros.h>
#include <future>

#define REFTIMES_PER_SEC  10000000
#define REFTIMES_PER_MILLISEC  10000
#define BITS_PER_BYTE 8
#define MA_AUDCLNT_E_SERVICE_NOT_RUNNING          ((HRESULT)0x88890010)

StreamCapture::StreamCapture(circular_buffer<int16_t> * iBuffer, std::atomic<bool> * mix_lock)
{
	pIBuffer = iBuffer;
	lock = mix_lock;
}

void StreamCapture::Init(circular_buffer<int16_t>* iBuffer, std::atomic<bool>* mix_lock)
{
	pIBuffer = iBuffer;
	lock = mix_lock;
}

HRESULT StreamCapture::ActivateAudioClient() {
	RETURN_IF_FAILED(CoInitializeEx(NULL, COINIT_MULTITHREADED));

	RETURN_IF_FAILED(CoCreateInstance(
		CLSID_MMDeviceEnumerator, NULL,
		CLSCTX_ALL, IID_IMMDeviceEnumerator,
		(void**)&pEnum));

	RETURN_IF_FAILED(pEnum->GetDefaultAudioEndpoint(eCapture, eConsole, &pDevice));

	RETURN_IF_FAILED(pDevice->Activate(
		IID_IAudioClient, CLSCTX_ALL,
		NULL, (void**)&pAudioClient
	));
	RETURN_IF_FAILED(pAudioClient->GetMixFormat(&pStreamFormat));
	
	pStreamFormat->wFormatTag = WAVE_FORMAT_PCM;
	pStreamFormat->nChannels = 1;
	pStreamFormat->nSamplesPerSec = 16000;
	pStreamFormat->wBitsPerSample = 16;
	pStreamFormat->nBlockAlign = pStreamFormat->nChannels * pStreamFormat->wBitsPerSample / BITS_PER_BYTE;
	pStreamFormat->nAvgBytesPerSec = pStreamFormat->nSamplesPerSec * pStreamFormat->nBlockAlign;
	pStreamFormat->cbSize = 0;

	RETURN_IF_FAILED(pAudioClient->Initialize(
		AUDCLNT_SHAREMODE_SHARED, AUDCLNT_STREAMFLAGS_AUTOCONVERTPCM,
		hnsBufferDuration, hnsPeriodicity,
		pStreamFormat, nullptr
	));

	return S_OK;
}

HRESULT StreamCapture::FinishCapture() {
	isDone = true;
	if (m_captureThread.joinable()) {
		m_captureThread.join();
	}
	RETURN_IF_FAILED(pAudioClient->Stop());
	audioFile.FixWAVHeader();

	return S_OK;
}

HRESULT StreamCapture::OnSampleReady() {
	// Sleep for half the buffer duration.
	//Sleep(hnsActualDuration / REFTIMES_PER_MILLISEC / 2);
	
	RETURN_IF_FAILED(pCaptureClient->GetNextPacketSize(&numFramesInNextPacket));

	while (numFramesInNextPacket != 0) {
		RETURN_IF_FAILED(pCaptureClient->GetBuffer(
			&nextDataPacketAddr, &numFramesAvailable,
			&flags, NULL, NULL
		));

		if (flags & AUDCLNT_BUFFERFLAGS_SILENT)
		{
			nextDataPacketAddr = NULL;  // Tell CopyData to write silence.
		}

		DWORD cbBytesToCapture = numFramesAvailable * pStreamFormat->nBlockAlign;

		pIBuffer->push(nextDataPacketAddr, numFramesAvailable);
		lock->store(false);
		//std::vector<int16_t> mergedAudio = streamMerger.Impose(pIBuffer, pOBuffer);

		DWORD dwBytesWritten = 0;
		RETURN_IF_WIN32_BOOL_FALSE(WriteFile(
			audioFile.m_hFile.get(),
			nextDataPacketAddr,
			cbBytesToCapture,
			&dwBytesWritten,
			NULL));

		RETURN_IF_FAILED(pCaptureClient->ReleaseBuffer(numFramesAvailable));


		audioFile.m_cbDataSize += cbBytesToCapture;

		RETURN_IF_FAILED(pCaptureClient->GetNextPacketSize(&numFramesInNextPacket));
	}

	return S_OK;
}

HRESULT StreamCapture::OnStartCapture() {
	RETURN_IF_FAILED(pAudioClient->GetBufferSize(&bufferFrameCount));
	RETURN_IF_FAILED(pAudioClient->GetService(IID_IAudioCaptureClient, (void**)&pCaptureClient));

	hnsActualDuration = (double)REFTIMES_PER_SEC *
		bufferFrameCount / pStreamFormat->nSamplesPerSec;

	RETURN_IF_FAILED(pAudioClient->Start());
}


HRESULT StreamCapture::StartCaptureAsync(LPCWSTR file)
{
	HRESULT hr = ActivateAudioClient();
	if (hr != S_OK)
	{
		throw std::exception("Excpetion ", hr);
		return hr;
	}

	audioFile.CreateWAVFile(*pStreamFormat, file);
	
	m_captureThread = std::thread([this]() {
		OnStartCapture();
		while (!isDone) {
			OnSampleReady();
		}
		});
}