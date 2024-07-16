#pragma once
#include <map>
#include <mmdeviceapi.h>
#include <tlhelp32.h>

class ProcessManager {
enum class PlatformsAvailable { Zoom, MicrosoftTeams, GoogleMeet };

public:
	//std::map<PlatformsAvailable, DWORD> GetAvailablePlatforms();
	__declspec(dllexport) DWORD FindProcessByName(PCWSTR processName);

private:
	HANDLE hSnapshot;
	PROCESSENTRY32 pe;
	BOOL hResult;

	__declspec(dllexport) void GetSnapshot();
	__declspec(dllexport) BOOL ValidateProcess(PCWSTR processName);
};