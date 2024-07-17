#pragma once
#include <mmeapi.h>
#include <basetsd.h>
#include <intsafe.h>

class StreamMerger {
public:
	__declspec(dllexport) void Impose(BYTE* nextDataPacketAddr, UINT32 numFramesAvailable, WAVEFORMATEX * pStreamFormat);

private:
	int lastFrame = 0;
};