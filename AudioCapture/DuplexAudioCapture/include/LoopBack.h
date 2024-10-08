#pragma once
#include <winnt.h>
#include <wtypes.h>

#include "circular_buffer.h"
class LoopBack {
public:
	LoopBack() {}
	virtual void Init(circular_buffer<int16_t>* iBuffer, HANDLE* capture_event) = 0;
	virtual HRESULT StartCaptureAsync(DWORD processId, bool includeProcessTree, PCWSTR file = L"output.wav") = 0;
};