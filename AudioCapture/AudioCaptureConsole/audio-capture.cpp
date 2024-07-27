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

	PCWSTR processName = L"Zoom.exe";
	DWORD processId = processManager.FindProcessByName(processName);

	audioRecorder.StartRecording(processId, true);
	/*
	auto trhead1 = std::thread(producer1);
	auto trhead2 = std::thread(producer2);
	auto trhead3 = std::thread(consumer);

	trhead1.join();
	trhead2.join();

	auto thread4 = std::thread(producer1);
	auto thread5 = std::thread(producer2);

	thread4.join();
	thread5.join();

	//std::this_thread::sleep_for(std::chrono::seconds(1));
	is_running.store(false);

	trhead3.join();
	*/
}