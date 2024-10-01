#include <iostream>
#include <guiddef.h>
#include <mmdeviceapi.h>
#include <Windows.h>

#include <FullDuplexAudioRecorder.h>
#include <ProcessManager.h>
#include <circular_buffer.h>
#include <thread>

#include <crtdbg.h>

//0x8Fuck0ff
int main()
{	
	ProcessManager processManager;
	std::unique_ptr<FullDuplexAudioRecorder> audioRecorder = std::make_unique<FullDuplexAudioRecorder>();

	PCWSTR processName = L"Zoom.exe";
	DWORD processId = processManager.FindProcessByName(processName);
	
	audioRecorder->StartRecording(processId, true);
	Sleep(3600000);
	audioRecorder->StopRecording();
}