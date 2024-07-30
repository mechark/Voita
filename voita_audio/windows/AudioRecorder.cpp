#include <vector>
#include <mfidl.h>
#include <flutter/standard_method_codec.h>
#include <algorithm>

#include "AudioRecorder.h"

AudioRecorder::AudioRecorder()
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

void AudioRecorder::Init(std::unique_ptr<FlEventSink> event_sink)
{
    sink = std::move(event_sink);
}

void AudioRecorder::mixing()
{
	Sleep(1500);
	while (is_mixing)
	{
		if (!lock_capture && !lock_loopback)
		{
			std::vector<int32_t> mixedFrame = streamMixer.Impose(&iBuffer, &oBuffer);
            sink->Success(flutter::EncodableValue(mixedFrame));

			lock_capture.store(true);
			lock_loopback.store(true);
		}
	}
}

HRESULT AudioRecorder::StartRecording(DWORD processId, bool includeTree)
{
	HRESULT hr = streamCapture.StartCaptureAsync();
    std::cout << std::hex << hr << std::endl;
	hr = loopbackCapture.StartCaptureAsync(processId, includeTree);
    std::cout << std::hex << hr;
	mixingThread = std::thread(&AudioRecorder::mixing, this);
    if (sink != nullptr) {
        while(sink);
    }

    RETURN_IF_FAILED(streamCapture.FinishCapture());
	RETURN_IF_FAILED(loopbackCapture.StopCaptureAsync());

	return hr;
}

HRESULT AudioRecorder::StopRecording()
{
	RETURN_IF_FAILED(streamCapture.FinishCapture());
	RETURN_IF_FAILED(loopbackCapture.StopCaptureAsync());

	// Kills mixingThread
	is_mixing.store(false);

	return S_OK;
}