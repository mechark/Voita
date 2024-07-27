#include "pch.h"

#include <map>
#include <mmdeviceapi.h>
#include <winternl.h>
#include "ProcessManager.h"

void ProcessManager::GetSnapshot() {
	hSnapshot = CreateToolhelp32Snapshot(TH32CS_SNAPPROCESS, 0);
	if (hSnapshot == INVALID_HANDLE_VALUE) hSnapshot = 0;
}

BOOL ProcessManager::ValidateProcess(PCWSTR processName) {
	if (_wcsicmp(pe.szExeFile, processName) == 0) {
		return true;
	}
	return false;
}

DWORD ProcessManager::FindProcessByName(PCWSTR processName) {
	GetSnapshot();

	if (hSnapshot != 0) {
		pe.dwSize = sizeof(PROCESSENTRY32);

		hResult = Process32First(hSnapshot, &pe);

		while (hResult) {
			if (ValidateProcess(processName)) {
				return pe.th32ProcessID;
			}

			hResult = Process32Next(hSnapshot, &pe);
		}
	}

	return 0;
}