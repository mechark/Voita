#include "pch.h"

#include <vector>
#include <mfidl.h>
#include "FullDuplexAudioRecorder.h"
#include "StreamMerger.h"

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

	streamCapture.Init(&iBuffer, &lock_loopback);
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
	while (true)
	{
		while (lock_capture || lock_loopback);
		size_t size = max(iBuffer.getFrameSize(), oBuffer.getFrameSize());
		std::vector<int16_t> mergedFrame(size);

		for (size_t i = 0; i < size; i++)
		{
			mergedFrame[i] = (iBuffer.read() + oBuffer.read()) / 2;
		}
		DWORD cbBytesToCapture = size * pStreamFormat.nBlockAlign;

		DWORD dwBytesWritten = 0;
		WriteFile(
			audioFile.m_hFile.get(),
			mergedFrame.data(),
			cbBytesToCapture,
			&dwBytesWritten,
			NULL);

		audioFile.m_cbDataSize += cbBytesToCapture;

		lock_capture.store(true);
		lock_loopback.store(true);
	}
}

HRESULT FullDuplexAudioRecorder::StartRecording(DWORD processId, bool includeTree) 
{
	audioFile.CreateWAVFile(pStreamFormat, L"duplex.wav");

	streamCapture.StartCaptureAsync(L"input.wav");
	loopbackCapture.StartCaptureAsync(processId, includeTree, L"output.wav");

	mixingThread = std::thread(&FullDuplexAudioRecorder::mixing, this);

	return S_OK;
}

HRESULT FullDuplexAudioRecorder::StopRecording()
{
	mixingThread.detach();
	streamCapture.FinishCapture();
	loopbackCapture.StopCaptureAsync();

	return S_OK;
}

