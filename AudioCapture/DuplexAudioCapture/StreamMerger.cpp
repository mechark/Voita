#include "pch.h"

#include <mmeapi.h>
#include <basetsd.h>
#include <intsafe.h>
#include <vector>

#include "StreamMerger.h"
#include "circular_buffer.h"

std::vector<int16_t> StreamMerger::Impose(circular_buffer<int16_t>* iBuffer, circular_buffer<int16_t>* oBuffer) {
	size_t frameSize = max(oBuffer->getFrameSize(), iBuffer->getFrameSize());
	std::vector<int16_t> mergedFrame(frameSize);

	for (size_t i = 0; i < frameSize; i++)
	{
		mergedFrame[i] = (iBuffer->read() + oBuffer->read()) / 2;
	}

	return mergedFrame;
}