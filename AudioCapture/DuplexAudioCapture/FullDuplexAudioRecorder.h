#pragma once

#include <vector>
#include <mfidl.h>

#include "LoopbackCapture.h"
#include "StreamCapture.h"
#include "circular_buffer.h"

#define BUFF_SIZE 1024

class FullDuplexAudioRecorder {
	public:
		__declspec(dllexport) FullDuplexAudioRecorder();
		__declspec(dllexport) HRESULT StartRecording(DWORD processId, bool includeTree);
		__declspec(dllexport) void StopRecording();

	private:
		StreamCapture streamCapture;
		WAVEFORMATEX pStreamFormat {};

		circular_buffer<int16_t> iBuffer;
		circular_buffer<int16_t> oBuffer;
};