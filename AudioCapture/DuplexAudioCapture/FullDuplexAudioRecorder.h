#pragma once

#include <vector>
#include <mfidl.h>

#include "LoopbackCapture.h"
#include "StreamCapture.h"


class FullDuplexAudioRecorder {
	public:

		__declspec(dllexport) HRESULT StartRecording(DWORD processId, bool includeTree);
		__declspec(dllexport) void StopRecording();

	private:
		StreamCapture streamCapture;
		WAVEFORMATEX pStreamFormat {};
};