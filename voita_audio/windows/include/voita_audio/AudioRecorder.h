#pragma once

#include <vector>
#include <mfidl.h>
#include <atomic>
#include <thread>

#include "LoopbackCapture.h"
#include "StreamCapture.h"
#include "circular_buffer.h"
#include "StreamMixer.h";
#include <flutter/event_sink.h>

#define BUFF_SIZE 1024
typedef flutter::EventSink<flutter::EncodableValue> FlEventSink;

class AudioRecorder {
	public:
		AudioRecorder();
        void Init(std::unique_ptr<FlEventSink> event_sink);
		HRESULT StartRecording(DWORD processId, bool includeTree);
		HRESULT StopRecording();

	private:
		StreamCapture streamCapture;
		CLoopbackCapture loopbackCapture;

		WAVEFORMATEX pStreamFormat{};
		AudioFile audioFile;
		StreamMixer streamMixer;

		std::thread mixingThread;

		std::atomic<bool> lock_capture;
		std::atomic<bool> lock_loopback;
		std::atomic<bool> is_mixing;

		circular_buffer<int16_t> iBuffer;
		circular_buffer<int16_t> oBuffer;

        std::unique_ptr<FlEventSink> sink;

		void mixing();
};