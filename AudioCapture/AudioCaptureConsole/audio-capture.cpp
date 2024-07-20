#include <iostream>
#include <guiddef.h>
#include <mmdeviceapi.h>
#include <Windows.h>

#include <FullDuplexAudioRecorder.h>
#include <ProcessManager.h>
#include <circular_buffer.h>
#include <thread>

std::atomic<int> cond_variable1(0);
std::atomic<int> cond_variable2(0);
std::atomic<bool> is_running(true);

void consumer()
{
	while (is_running)
	{
		std::cout << cond_variable1.is_lock_free() << cond_variable2.is_lock_free();
		while (cond_variable1.load() == 0 || cond_variable2.load() == 0);
		std::cout << "Do something\n";
		cond_variable1.store(0);
	}
}

void producer1()
{
	for (int i = 0; i < 100000; i++)
	{
		int k = 0;
	}

	std::cout << "Data is here1\n";
	cond_variable1.store(1);
}

void producer2()
{
	for (int i = 0; i < 100000; i++)
	{
		int k = 0;
	}

	std::cout << "Data is here2\n";
	cond_variable2.store(1);
}

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