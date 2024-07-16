#pragma once
#include <mmdeviceapi.h>

class Sink {
	public:
		void CopyData(BYTE* nextDataPacketAddr, UINT32 numFramesAvailable);
};