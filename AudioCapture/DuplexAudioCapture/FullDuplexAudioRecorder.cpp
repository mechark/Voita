#include "pch.h"

#include <vector>
#include <mfidl.h>
#include "FullDuplexAudioRecorder.h"

HRESULT FullDuplexAudioRecorder::StartRecording(DWORD processId, bool includeTree) {

    CLoopbackCapture loopbackCapture;
	loopbackCapture.StartCaptureAsync(processId, includeTree, L"output.wav");

	streamCapture.StartCaptureAsync(L"input.wav");
	Sleep(10000);
	streamCapture.FinishCapture();
	loopbackCapture.StopCaptureAsync();

	return S_OK;
}