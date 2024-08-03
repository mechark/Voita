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
	Sleep(10000);
	audioRecorder.StopRecording();
	
	/*
	circular_buffer<int16_t> buff(1024);
	int mixed = 321;
	int16_t res = static_cast<int16_t>(mixed);
	buff.push(&res);
	res = 513;
	buff.push(&res);
	res = 1234;
	buff.push(&res);

	for (int i = 0; i < 3; i++)
	{
		std::cout << *buff.getTail() << " ";
		buff.pushTail(1);
	}
	*/
}