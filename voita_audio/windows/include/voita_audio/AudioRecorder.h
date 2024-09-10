#pragma once

#include <vector>
#include <mfidl.h>
#include <atomic>
#include <thread>
#include <future>

#include <LoopbackCapture.h>
#include <StreamCapture.h>
#include <circular_buffer.h>
#include <StreamMixer.h>;
#include <flutter/event_sink.h>
#include <functional>

#define BUFF_SIZE 1024
typedef flutter::EventSink<flutter::EncodableValue> FlEventSink;

class AudioRecorder {
	public:
		AudioRecorder(HWND message_window);
		~AudioRecorder();
		HRESULT StartRecording(DWORD processId, bool includeTree);
		HRESULT StopRecording();

	private:
		std::unique_ptr<StreamCapture> streamCapture;
		ComPtr<CLoopbackCapture> loopbackCapture;

		WAVEFORMATEX pStreamFormat{};
		AudioFile audioFile;
		StreamMixer streamMixer;

		std::future<void> mixingThread;

		HANDLE capture_event;
		HANDLE loopback_event;
		std::atomic<bool> is_mixing;

		circular_buffer<int16_t> iBuffer;
		circular_buffer<int16_t> oBuffer;
		std::vector<int32_t> mixedBuffer;

		HWND message_window_;
		static const UINT WM_AUDIO_FRAME = WM_USER + 1;

		void mixing();
};