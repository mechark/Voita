#include "pch.h"

#include <vector>
#include <mfidl.h>
#include "FullDuplexAudioRecorder.h"

FullDuplexAudioRecorder::FullDuplexAudioRecorder() 
	: iBuffer(BUFF_SIZE), oBuffer(BUFF_SIZE)
{
}

HRESULT FullDuplexAudioRecorder::StartRecording(DWORD processId, bool includeTree) 
{
    CLoopbackCapture loopbackCapture(&oBuffer);
	StreamCapture streamCapture(&iBuffer, &oBuffer);

	loopbackCapture.StartCaptureAsync(processId, includeTree, L"output.wav");
	streamCapture.StartCaptureAsync(L"input.wav");

	Sleep(10000);

	streamCapture.FinishCapture();
	loopbackCapture.StopCaptureAsync();

	return S_OK;
}