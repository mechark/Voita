#pragma once

#include <vector>
#include <mfidl.h>
#include <atomic>
#include <thread>
#include <mutex>
#include <future>
#include <condition_variable>

#include "LoopbackCapture.h"
#include "StreamCapture.h"
#include "circular_buffer.h"
#include "StreamMixer.h";
#include "AudioFile.h"
#include "LoopbackCapture.h"
#include "FullLoopbackCapture.h"

#define BUFF_SIZE 1024

class FullDuplexAudioRecorder {
	public:
		__declspec(dllexport) FullDuplexAudioRecorder();
		__declspec(dllexport) ~FullDuplexAudioRecorder();
		__declspec(dllexport) HRESULT StartRecording(DWORD processId, bool includeTree);
		__declspec(dllexport) HRESULT StopRecording();

	private:
		std::unique_ptr<StreamCapture> streamCapture;
		std::unique_ptr<FullLoopbackCapture> fullLoopbackCapture;
		ComPtr<CLoopbackCapture> loopbackCapture;

		WAVEFORMATEX pStreamFormat{};
		AudioFile audioFile;
		StreamMixer streamMixer;

		std::atomic<bool> is_mixing;
		std::atomic<bool> is_full_loopback;
		std::future<void> mixingThread;

		HANDLE capture_event;
		HANDLE loopback_event;
		
		circular_buffer<int16_t> iBuffer;
		circular_buffer<int16_t> oBuffer;
		circular_buffer<int32_t> mixedBuffer;
		
		__declspec(dllexport) void mixing();
};