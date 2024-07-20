#pragma once
#include <mmeapi.h>
#include <basetsd.h>
#include <intsafe.h>
#include <vector>

#include "circular_buffer.h"

class StreamMerger {
public:
	__declspec(dllexport) std::vector<int16_t> Impose(circular_buffer<int16_t> * iBuffer, circular_buffer<int16_t>* oBuffer);

private:
	int lastFrame = 0;
};