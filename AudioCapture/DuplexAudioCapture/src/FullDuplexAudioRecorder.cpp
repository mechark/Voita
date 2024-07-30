#include "pch.h"

#include <vector>
#include <mfidl.h>
#include "FullDuplexAudioRecorder.h"
#include <algorithm>

FullDuplexAudioRecorder::FullDuplexAudioRecorder()
	: iBuffer(BUFF_SIZE), oBuffer(BUFF_SIZE)
{
	pStreamFormat.wFormatTag = WAVE_FORMAT_PCM;
	pStreamFormat.nChannels = 1;
	pStreamFormat.nSamplesPerSec = 16000;
	pStreamFormat.wBitsPerSample = 16;
	pStreamFormat.nBlockAlign = pStreamFormat.nChannels * pStreamFormat.wBitsPerSample / 8;
	pStreamFormat.nAvgBytesPerSec = pStreamFormat.nSamplesPerSec * pStreamFormat.nBlockAlign;
	pStreamFormat.cbSize = 0;

	lock_capture.store(true);
	lock_loopback.store(true);
	is_mixing.store(true);

	streamCapture.Init(&iBuffer, &lock_capture);
	loopbackCapture.Init(&oBuffer, &lock_loopback);
}

FullDuplexAudioRecorder::~FullDuplexAudioRecorder()
{
	mixingThread.detach();
	streamCapture.FinishCapture();
	loopbackCapture.StopCaptureAsync();
}

void FullDuplexAudioRecorder::mixing()
{
	Sleep(1500);
	while (is_mixing)
	{
		if (!lock_capture && !lock_loopback)
		{
			std::vector<int32_t> mixedFrame = streamMixer.Impose(&iBuffer, &oBuffer);

			/*
			DWORD cbBytesToCapture = mixedFrame.size() * pStreamFormat.nBlockAlign;
			DWORD dwBytesWritten = 0;
			WriteFile(
				audioFile.m_hFile.get(),
				mixedFrame.data(),
				cbBytesToCapture,
				&dwBytesWritten,
				NULL);

			audioFile.m_cbDataSize += cbBytesToCapture;*/

			lock_capture.store(true);
			lock_loopback.store(true);
		}
	}
}

HRESULT FullDuplexAudioRecorder::StartRecording(DWORD processId, bool includeTree)
{
	//audioFile.CreateWAVFile(pStreamFormat, L"duplex.wav");

	streamCapture.StartCaptureAsync();
	loopbackCapture.StartCaptureAsync(processId, includeTree);

	mixingThread = std::thread(&FullDuplexAudioRecorder::mixing, this);

	return S_OK;
}

HRESULT FullDuplexAudioRecorder::StopRecording()
{
	RETURN_IF_FAILED(streamCapture.FinishCapture());
	RETURN_IF_FAILED(loopbackCapture.StopCaptureAsync());

	// Kills mixingThread
	is_mixing.store(false);

	//RETURN_IF_FAILED(audioFile.FixWAVHeader());

	return S_OK;
}