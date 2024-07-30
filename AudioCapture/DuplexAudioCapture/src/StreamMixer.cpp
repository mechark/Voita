#include "pch.h"

#include <mmeapi.h>
#include <basetsd.h>
#include <intsafe.h>
#include <vector>

#include "StreamMixer.h"
#include "circular_buffer.h"

std::vector<int32_t> StreamMixer::Impose(circular_buffer<int16_t>* iBuffer, circular_buffer<int16_t>* oBuffer) {
	size_t frameSize = max(oBuffer->getFrameSize(), iBuffer->getFrameSize());
	std::vector<int32_t> mixedFrame(frameSize);

	for (size_t i = 0; i < frameSize; i++)
	{
		int ival = iBuffer->read();
		int oval = oBuffer->read();
		int mixed = 0;

		ival += MAX_AMPLITUDE;
		oval += MAX_AMPLITUDE;

		if ((ival < MAX_AMPLITUDE) || (oval < MAX_AMPLITUDE))
			mixed = ival * oval / MAX_AMPLITUDE;
		else
			mixed = 2 * (ival + oval) - (ival * oval) / MAX_AMPLITUDE - 2 * MAX_AMPLITUDE;

		if (mixed == 2 * MAX_AMPLITUDE) mixed = 2 * MAX_AMPLITUDE;
		mixed += INT16_MIN;

		mixedFrame[i] = static_cast<int32_t>(mixed);
	}

	return mixedFrame;
}