#include <vector>
#include <mfidl.h>
#include <flutter/standard_method_codec.h>
#include <algorithm>
#include <thread>

#include "AudioRecorder.h"

AudioRecorder::AudioRecorder(HWND message_window)
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

	message_window_ = message_window;
}

void AudioRecorder::mixing()
{
	Sleep(1500);
	while (is_mixing)
	{
		if (!lock_capture && !lock_loopback)
		{
			std::vector<int32_t> mixedFrame = streamMixer.Impose(&iBuffer, &oBuffer);
			mixedBuffer.assign(mixedFrame.begin(), mixedFrame.end());
			
			auto pVec = mixedBuffer.data();
            PostMessage(message_window_, WM_AUDIO_FRAME, mixedFrame.size(), reinterpret_cast<LPARAM>(pVec));

			lock_capture.store(true);
			lock_loopback.store(true);
		}
	}
}

HRESULT AudioRecorder::StartRecording(DWORD processId, bool includeTree)
{
	HRESULT hr = streamCapture.StartCaptureAsync();
    if (hr != S_OK) throw std::exception("Failed to start microphone capture");
	hr = loopbackCapture.StartCaptureAsync(processId, includeTree);
    if (hr != S_OK) throw std::exception("Failed to start loopback capture");
	mixingThread = std::thread(&AudioRecorder::mixing, this);

	return hr;
}

HRESULT AudioRecorder::StopRecording()
{
	RETURN_IF_FAILED(streamCapture.FinishCapture());
	RETURN_IF_FAILED(loopbackCapture.StopCaptureAsync());

	// Kills mixingThread
	is_mixing.store(false);
	if (mixingThread.joinable()) {
		mixingThread.join();
		is_mixing = true;
	}

	return S_OK;
}