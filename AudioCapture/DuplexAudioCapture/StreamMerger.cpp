#include "pch.h"

#include <mmeapi.h>
#include <basetsd.h>
#include <intsafe.h>

#include "StreamMerger.h"

void StreamMerger::Impose(BYTE* nextDataPacketAddr, UINT32 numFramesAvailable, WAVEFORMATEX* pStreamFormat) {
	DWORD cbBytesToCapture = numFramesAvailable * pStreamFormat->nBlockAlign;

	
}