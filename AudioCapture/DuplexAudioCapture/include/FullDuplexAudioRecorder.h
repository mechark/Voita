#pragma once

#include <vector>
#include <mfidl.h>
#include <atomic>
#include <thread>

#include "LoopbackCapture.h"
#include "StreamCapture.h"
#include "circular_buffer.h"
#include "AudioFile.h"

#define BUFF_SIZE 1024
#define MAX_AMPLITUDE 32768

class FullDuplexAudioRecorder {
	public:
		__declspec(dllexport) FullDuplexAudioRecorder();
		__declspec(dllexport) ~FullDuplexAudioRecorder();
		__declspec(dllexport) HRESULT StartRecording(DWORD processId, bool includeTree);
		__declspec(dllexport) HRESULT StopRecording();

	private:
		StreamCapture streamCapture;
		CLoopbackCapture loopbackCapture;

		WAVEFORMATEX pStreamFormat{};
		AudioFile audioFile;

		std::thread mixingThread;
		std::atomic<bool> lock_capture;
		std::atomic<bool> lock_loopback;
		std::atomic<bool> is_mixing;

		circular_buffer<int16_t> iBuffer;
		circular_buffer<int16_t> oBuffer;


		__declspec(dllexport) void mixing();
};