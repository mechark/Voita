#include <vector>
#include <mfidl.h>
#include <flutter/standard_method_codec.h>
#include <algorithm>
#include <thread>
#include <future>

#include "AudioRecorder.h"

AudioRecorder::AudioRecorder(HWND message_window)
	: iBuffer(BUFF_SIZE), oBuffer(BUFF_SIZE)
{
	streamCapture = std::make_unique<StreamCapture>();
	loopbackCapture = Microsoft::WRL::Make<CLoopbackCapture>();

	pStreamFormat.wFormatTag = WAVE_FORMAT_PCM;
	pStreamFormat.nChannels = 1;
	pStreamFormat.nSamplesPerSec = 16000;
	pStreamFormat.wBitsPerSample = 16;
	pStreamFormat.nBlockAlign = pStreamFormat.nChannels * pStreamFormat.wBitsPerSample / 8;
	pStreamFormat.nAvgBytesPerSec = pStreamFormat.nSamplesPerSec * pStreamFormat.nBlockAlign;
	pStreamFormat.cbSize = 0;

	is_mixing.store(true);

	capture_event = CreateEventA(NULL, TRUE, FALSE, "CaptureEvent");
	loopback_event = CreateEventA(NULL, TRUE, FALSE, "LoopbackEvent");
	
	streamCapture->Init(&iBuffer, &capture_event);
	loopbackCapture->Init(&oBuffer, &loopback_event);

	message_window_ = message_window;
}

AudioRecorder::~AudioRecorder()
{
	CloseHandle(capture_event);
	CloseHandle(loopback_event);
}

void AudioRecorder::mixing()
{
	HANDLE events[2] = { capture_event, loopback_event };
	Sleep(1500);
	while (is_mixing)
	{
		DWORD res = WaitForMultipleObjects(2, events, TRUE, 100);
		if (res == WAIT_OBJECT_0) {
			std::vector<int32_t> mixedFrame = streamMixer.Impose(&iBuffer, &oBuffer);
			mixedBuffer.assign(mixedFrame.begin(), mixedFrame.end());

			auto pVec = mixedBuffer.data();
            PostMessage(message_window_, WM_AUDIO_FRAME, mixedFrame.size(), reinterpret_cast<LPARAM>(pVec));

			ResetEvent(capture_event);
			ResetEvent(loopback_event);
		}
	}
}

HRESULT AudioRecorder::StartRecording(DWORD processId, bool includeTree)
{
	HRESULT hr = streamCapture->StartCaptureAsync();
    if (hr != S_OK) throw std::exception("Failed to start microphone capture");
	hr = loopbackCapture->StartCaptureAsync(processId, includeTree);
    if (hr != S_OK) throw std::exception("Failed to start loopback capture");
	mixingThread = std::async(std::launch::async, &AudioRecorder::mixing, this);

	return hr;
}

HRESULT AudioRecorder::StopRecording()
{
	RETURN_IF_FAILED(streamCapture->FinishCapture());
	RETURN_IF_FAILED(loopbackCapture->StopCaptureAsync());

	// Kills mixingThread
	is_mixing.store(false);
	if (mixingThread.valid()) {
		mixingThread.wait(); 
	}

	return S_OK;
}