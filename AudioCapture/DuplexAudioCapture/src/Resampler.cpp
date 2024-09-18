#include "pch.h"

#include "Resampler.h"
#include <wil/result_macros.h>
#include <initguid.h>
#include <mfapi.h>
#include <mfidl.h>
#include <mfreadwrite.h>
#include <mftransform.h>
#include <wmcodecdsp.h>
#include <wrl/client.h>

#define BITS_PER_BYTE 8

using Microsoft::WRL::ComPtr;

Resampler::Resampler()
{
	HRESULT hr = InitResampler();
	if (hr != S_OK)
	{
		throw E_UNEXPECTED;
	}
}

HRESULT Resampler::InitResampler()
{
	RETURN_IF_FAILED(MFStartup(MF_VERSION));

	RETURN_IF_FAILED(CreateDSPAudioResampler());

	return S_OK;
}

HRESULT Resampler::CreateDSPAudioResampler()
{
	// If there will be some erros, remember this
	// CLSCTX_INPROC_SERVER 
	// (The code that creates and manages objects of this class is a DLL that runs in the same process as the caller of the function specifying the class context.)

	// Creating resampler object
	RETURN_IF_FAILED(CoCreateInstance(CLSID_CResamplerMediaObject, NULL, CLSCTX_INPROC_SERVER, IID_IUnknown, (void**)&spTransformUnk));

	RETURN_IF_FAILED(spTransformUnk.As(&spTransform));
	
	return S_OK;
}

HRESULT Resampler::ProcessAudioSample(BYTE* data, DWORD iBufferSize, BYTE* oData, DWORD *outputCurrentLength)
{
	// Get factor for output buffer
	oBufferFactor = GetOutputBufferFactor();
	
	// Create input buffer
	RETURN_IF_FAILED(CreateInputBuffer(iBufferSize, data));

	// Audio data conversion from input
	RETURN_IF_FAILED(spTransform->ProcessInput(0, spInputSample.Get(), 0));
	
	// Create output buffer
	RETURN_IF_FAILED(CreateOutputBuffer(iBufferSize));

	// Get audio data to the outputDataBuffer
	outputDataBuffer.pSample = spOutputSample.Get();

	DWORD dwStatus = 0;
	RETURN_IF_FAILED(spTransform->ProcessOutput(0, 1, &outputDataBuffer, &dwStatus));

	// Get converted audio data to the spOutputBuffer
	RETURN_IF_FAILED(outputDataBuffer.pSample->GetBufferByIndex(0, &spOutputBuffer));

	BYTE* pbSample = nullptr;
	DWORD cbMaxLength = 0;
	DWORD pcbCurrentLength = 0;
	// Get converted data and it's outputCurrentLength out
	RETURN_IF_FAILED(spOutputBuffer->Lock(&pbSample, &cbMaxLength, outputCurrentLength));

	memcpy(oData, pbSample, *outputCurrentLength);

	RETURN_IF_FAILED(spOutputBuffer->Unlock());

	if (outputCurrentLength == 0){
		return E_UNEXPECTED;
	}

	return S_OK;
}

HRESULT Resampler::SetInputAudioFormat(int sampleRate, int channelsNumber, int bitsPerSample)
{
	UINT32 nBlockAlign = channelsNumber * bitsPerSample / BITS_PER_BYTE;

	// Create and set input type
	RETURN_IF_FAILED(MFCreateMediaType(&spInputType));

	RETURN_IF_FAILED(spInputType->SetGUID(MF_MT_MAJOR_TYPE, MFMediaType_Audio));
	RETURN_IF_FAILED(spInputType->SetGUID(MF_MT_SUBTYPE, MFAudioFormat_PCM));
	RETURN_IF_FAILED(spInputType->SetUINT32(MF_MT_AUDIO_BITS_PER_SAMPLE, bitsPerSample));
	RETURN_IF_FAILED(spInputType->SetUINT32(MF_MT_AUDIO_SAMPLES_PER_SECOND, sampleRate));
	RETURN_IF_FAILED(spInputType->SetUINT32(MF_MT_AUDIO_NUM_CHANNELS, channelsNumber));
	RETURN_IF_FAILED(spInputType->SetUINT32(MF_MT_AUDIO_BLOCK_ALIGNMENT, nBlockAlign));
	RETURN_IF_FAILED(spInputType->SetUINT32(MF_MT_AUDIO_AVG_BYTES_PER_SECOND, sampleRate * nBlockAlign));
	
	RETURN_IF_FAILED(spTransform->SetInputType(0, spInputType.Get(), 0));

	return S_OK;
}

HRESULT Resampler::SetOutputAudioFormat(int sampleRate, int channelsNumber, int bitsPerSample)
{
	UINT32 nBlockAlign = channelsNumber * bitsPerSample / BITS_PER_BYTE;

	// Create and set input type
	RETURN_IF_FAILED(MFCreateMediaType(&spOutputType));

	RETURN_IF_FAILED(spOutputType->SetGUID(MF_MT_MAJOR_TYPE, MFMediaType_Audio));
	RETURN_IF_FAILED(spOutputType->SetGUID(MF_MT_SUBTYPE, MFAudioFormat_PCM));
	RETURN_IF_FAILED(spOutputType->SetUINT32(MF_MT_AUDIO_BITS_PER_SAMPLE, bitsPerSample));
	RETURN_IF_FAILED(spOutputType->SetUINT32(MF_MT_AUDIO_SAMPLES_PER_SECOND, sampleRate));
	RETURN_IF_FAILED(spOutputType->SetUINT32(MF_MT_AUDIO_NUM_CHANNELS, channelsNumber));
	RETURN_IF_FAILED(spOutputType->SetUINT32(MF_MT_AUDIO_BLOCK_ALIGNMENT, nBlockAlign));
	RETURN_IF_FAILED(spOutputType->SetUINT32(MF_MT_AUDIO_AVG_BYTES_PER_SECOND, sampleRate * nBlockAlign));

	RETURN_IF_FAILED(spTransform->SetOutputType(0, spOutputType.Get(), 0));

	return S_OK;
}

HRESULT Resampler::CreateInputBuffer(DWORD iBufferSize, BYTE * data)
{
	BYTE* pbSample = nullptr;
	DWORD cbMaxLength = 0;
	DWORD pcbCurrentLength = 0;

	RETURN_IF_FAILED(MFCreateSample(&spInputSample));

	RETURN_IF_FAILED(MFCreateMemoryBuffer(iBufferSize, &spInputBuffer));

	RETURN_IF_FAILED(spInputBuffer->Lock(&pbSample, &cbMaxLength, &pcbCurrentLength));

	memcpy(pbSample, data, iBufferSize);
	
	RETURN_IF_FAILED(spInputBuffer->SetCurrentLength(iBufferSize));

	if (cbMaxLength == 0)
	{
		return E_UNEXPECTED;
	}

	RETURN_IF_FAILED(spInputBuffer->Unlock());

	RETURN_IF_FAILED(spInputSample->AddBuffer(spInputBuffer.Get()));

	return S_OK;
}

HRESULT Resampler::CreateOutputBuffer(DWORD iBufferSize)
{
	RETURN_IF_FAILED(MFCreateSample(&spOutputSample));

	RETURN_IF_FAILED(MFCreateMemoryBuffer(iBufferSize * oBufferFactor, &spOutputBuffer));

	RETURN_IF_FAILED(spOutputSample->AddBuffer(spOutputBuffer.Get()));

	return S_OK;
}

int Resampler::GetOutputBufferFactor()
{
	// Gets the factor by which iBufferSize multiplied
	// to meet the size of the converted data

	int factor = 1;
	UINT32 iSamplesRate;
	UINT32 oSamplesRate;
	UINT32 iChannlesNumber;
	UINT32 oChannlesNumber;

	spInputType->GetUINT32(MF_MT_AUDIO_SAMPLES_PER_SECOND, &iSamplesRate);
	spOutputType->GetUINT32(MF_MT_AUDIO_SAMPLES_PER_SECOND, &oSamplesRate);

	spInputType->GetUINT32(MF_MT_AUDIO_NUM_CHANNELS, &iChannlesNumber);
	spInputType->GetUINT32(MF_MT_AUDIO_NUM_CHANNELS, &oChannlesNumber);

	if (iSamplesRate < oSamplesRate)
	{
		factor *= int(oSamplesRate / iSamplesRate);
	}

	if (iChannlesNumber < oChannlesNumber)
	{
		factor *= int(oChannlesNumber / iChannlesNumber);
	}

	return factor;
}