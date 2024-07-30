#include <iostream>
#include <guiddef.h>
#include <mmdeviceapi.h>
#include <Windows.h>

#include <FullDuplexAudioRecorder.h>
#include <ProcessManager.h>
#include <circular_buffer.h>
#include <thread>

int main()
{
	ProcessManager processManager;
	FullDuplexAudioRecorder audioRecorder;

	PCWSTR processName = L"Firefox.exe";
	DWORD processId = processManager.FindProcessByName(processName);

	audioRecorder.StartRecording(processId, true);
	Sleep(20000);
	audioRecorder.StopRecording();
}