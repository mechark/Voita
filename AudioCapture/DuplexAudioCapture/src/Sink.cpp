#include "pch.h"

#include <mmdeviceapi.h>
#include "Sink.h"
#include <vector>
#include <iostream>
#include <stdint.h>
#include <cstdint>

void Sink::CopyData(BYTE* nextDataPacketAddr, UINT32 numFramesAvailable) {
	std::vector<int16_t> dataFrame(sizeof(int16_t) * numFramesAvailable);

	void * pData = memcpy(dataFrame.data(), nextDataPacketAddr, sizeof(int16_t) * numFramesAvailable);

	for (int16_t i : dataFrame) {
		std::cout << i << '\n';
	}
}