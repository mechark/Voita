#include <iostream>
#include <guiddef.h>
#include <mmdeviceapi.h>
#include <Windows.h>

#include <FullDuplexAudioRecorder.h>
#include <ProcessManager.h>


int main()
{
	ProcessManager processManager;
	FullDuplexAudioRecorder audioRecorder;

	PCWSTR processName = L"Spotify.exe";
	DWORD processId = processManager.FindProcessByName(processName);

	audioRecorder.StartRecording(processId, true);
}