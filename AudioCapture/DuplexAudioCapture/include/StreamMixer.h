#pragma once
#include <mmeapi.h>
#include <basetsd.h>
#include <intsafe.h>
#include <vector>

#include "circular_buffer.h"

#define MAX_AMPLITUDE 32768

class StreamMixer {
public:
	__declspec(dllexport) std::vector<int32_t> Impose(circular_buffer<int16_t> * iBuffer, circular_buffer<int16_t>* oBuffer);
	__declspec(dllexport) std::vector<int16_t> Impose(circular_buffer<int16_t> * iBuffer, circular_buffer<int16_t>* oBuffer, int debug);

private:
	int lastFrame = 0;
};