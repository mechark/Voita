#include "pch.h"

#include <vector>
#include <mfidl.h>
#include "FullDuplexAudioRecorder.h"
#include <mutex>
#include <condition_variable>
#include <algorithm>
#include <future>

FullDuplexAudioRecorder::FullDuplexAudioRecorder()
	: iBuffer(BUFF_SIZE), oBuffer(BUFF_SIZE), mixedBuffer(BUFF_SIZE)
{
	streamCapture = std::make_unique<StreamCapture>();
	fullLoopbackCapture = std::make_unique<FullLoopbackCapture>();
	loopbackCapture = Microsoft::WRL::Make<CLoopbackCapture>();

	pStreamFormat.wFormatTag = WAVE_FORMAT_PCM;
	pStreamFormat.nChannels = 1;
	pStreamFormat.nSamplesPerSec = 16000;
	pStreamFormat.wBitsPerSample = 16;
	pStreamFormat.nBlockAlign = pStreamFormat.nChannels * pStreamFormat.wBitsPerSample / 8;
	pStreamFormat.nAvgBytesPerSec = pStreamFormat.nSamplesPerSec * pStreamFormat.nBlockAlign;
	pStreamFormat.cbSize = 0;

	is_mixing.store(true);
	is_full_loopback.store(false);
	
	capture_event = CreateEventA(NULL, TRUE, FALSE, "CaptureEvent");
	loopback_event = CreateEventA(NULL, TRUE, FALSE, "LoopbackEvent");
	
	streamCapture->Init(&iBuffer, &capture_event);
	fullLoopbackCapture->Init(&oBuffer, &loopback_event);
	loopbackCapture->Init(&oBuffer, &loopback_event);
}

FullDuplexAudioRecorder::~FullDuplexAudioRecorder()
{
	CloseHandle(capture_event);
	CloseHandle(loopback_event);
}

void FullDuplexAudioRecorder::mixing()
{
	
	HANDLE events[2] = { capture_event, loopback_event };
	Sleep(1500);
	while (is_mixing.load())
	{
		DWORD res = WaitForMultipleObjects(2, events, TRUE, 100);
		if (res == WAIT_OBJECT_0) {

			std::vector<int16_t> frame = streamMixer.Impose(&iBuffer, &oBuffer, 1);
			
			DWORD cbBytesToCapture = frame.size() * pStreamFormat.nBlockAlign;
			DWORD dwBytesWritten = 0;
			
			WriteFile(
				audioFile.m_hFile.get(),
				frame.data(),
				cbBytesToCapture,
				&dwBytesWritten,
				NULL);

			audioFile.m_cbDataSize += cbBytesToCapture;
			
			ResetEvent(capture_event);
			ResetEvent(loopback_event);
		}
		else {

		}
	}
}

HRESULT FullDuplexAudioRecorder::StartRecording(DWORD processId, bool includeTree)
{
	audioFile.CreateWAVFile(pStreamFormat, L"duplex.wav");

	// Fork
	if (processId == 0) {
		fullLoopbackCapture->StartCaptureAsync(processId, includeTree);
		is_full_loopback.store(true);
	}
	else {
		loopbackCapture->StartCaptureAsync(processId, includeTree);
	}
	streamCapture->StartCaptureAsync();

	mixingThread = std::async(std::launch::async, &FullDuplexAudioRecorder::mixing, this);
	//auto thread = std::thread(&FullDuplexAudioRecorder::mixing, this);

	return S_OK;
}

HRESULT FullDuplexAudioRecorder::StopRecording()
{
	RETURN_IF_FAILED(streamCapture->FinishCapture());
	if (is_full_loopback) {
		RETURN_IF_FAILED(fullLoopbackCapture->FinishCapture());
	}
	else {
		RETURN_IF_FAILED(loopbackCapture->StopCaptureAsync());
	}

	// Kills mixingThread
	is_mixing.store(false);
	if (mixingThread.valid()) {
		mixingThread.wait(); 
	}

	RETURN_IF_FAILED(audioFile.FixWAVHeader());

	return S_OK;
}