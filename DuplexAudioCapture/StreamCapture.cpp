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

HRESULT StreamCapture::TransformToWAVEFORMATEX(WAVEFORMATEXTENSIBLE* pStreamFormatExtensible) {
	// I don't give a fuck that it looks ugly, so should you or me in the future
	if (IsEqualGUID(pStreamFormatExtensible->SubFormat, KSDATAFORMAT_SUBTYPE_PCM)) {
		pStreamFormat->wFormatTag = WAVE_FORMAT_PCM;
	}
	else if (IsEqualGUID(pStreamFormatExtensible->SubFormat, KSDATAFORMAT_SUBTYPE_IEEE_FLOAT)) {
		pStreamFormat->wFormatTag = WAVE_FORMAT_IEEE_FLOAT;
	}
	else if (IsEqualGUID(pStreamFormatExtensible->SubFormat, KSDATAFORMAT_SUBTYPE_DRM)) {
		pStreamFormat->wFormatTag = WAVE_FORMAT_DRM;
	}
	else if (IsEqualGUID(pStreamFormatExtensible->SubFormat, KSDATAFORMAT_SUBTYPE_ALAW)) {
		pStreamFormat->wFormatTag = WAVE_FORMAT_ALAW;
	}
	else if (IsEqualGUID(pStreamFormatExtensible->SubFormat, KSDATAFORMAT_SUBTYPE_MULAW)) {
		pStreamFormat->wFormatTag = WAVE_FORMAT_MULAW;
	}
	else if (IsEqualGUID(pStreamFormatExtensible->SubFormat, KSDATAFORMAT_SUBTYPE_ADPCM)) {
		pStreamFormat->wFormatTag = WAVE_FORMAT_ADPCM;
	}

	pStreamFormat->cbSize = 0;

	return S_OK;
}

HRESULT StreamCapture::ActivateAudioClient(WAVEFORMATEX * streamFormat) {
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

	// Transform to the proper format
	WAVEFORMATEXTENSIBLE* streamFormatExtensible = reinterpret_cast<WAVEFORMATEXTENSIBLE*>(pStreamFormat);
	RETURN_IF_FAILED(TransformToWAVEFORMATEX(streamFormatExtensible));

	RETURN_IF_FAILED(pAudioClient->Initialize(
		AUDCLNT_SHAREMODE_SHARED, 0,
		hnsBufferDuration, hnsPeriodicity,
		pStreamFormat, nullptr
	));

	*streamFormat = *pStreamFormat;

	return S_OK;
}

HRESULT StreamCapture::FinishCapture() {
	//OnFinishCapture();
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
	
	Sleep(hnsActualDuration / REFTIMES_PER_MILLISEC / 2);
	
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

void StreamCapture::OnStartCapture() {
	pAudioClient->GetBufferSize(&bufferFrameCount);
	std::cout << "OnStartCapture: " << std::this_thread::get_id();
	pAudioClient->GetService(IID_IAudioCaptureClient, (void**)&pCaptureClient);

	hnsActualDuration = (double)REFTIMES_PER_SEC *
		bufferFrameCount / pStreamFormat->nSamplesPerSec;

	pAudioClient->Start();
}


void StreamCapture::StartCaptureAsync(LPCWSTR file)
{
	audioFile.CreateWAVFile(*pStreamFormat, file);
	m_captureThread = std::thread([this]() {
		OnStartCapture();
		while (!isDone) {
			OnSampleReady();
		}
	});
}