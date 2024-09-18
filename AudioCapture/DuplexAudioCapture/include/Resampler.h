#pragma once
#include <mfapi.h>
#include <mfidl.h>
#include <mfreadwrite.h>
#include <mftransform.h>
#include <wmcodecdsp.h>
#include <wrl/client.h>

using Microsoft::WRL::ComPtr;

class Resampler 
{
public:
	__declspec(dllexport) Resampler();
	__declspec(dllexport) HRESULT ProcessAudioSample(BYTE* data, DWORD iBufferSize, BYTE* oData, DWORD *outputCurrentLength);
	__declspec(dllexport) HRESULT SetInputAudioFormat(int sampleRate, int channelsNumber, int bitsPerSample);
	__declspec(dllexport) HRESULT SetOutputAudioFormat(int sampleRate, int channelsNumber, int bitsPerSample);

private:
	__declspec(dllexport) HRESULT InitResampler();
	__declspec(dllexport) HRESULT CreateDSPAudioResampler();
	__declspec(dllexport) HRESULT CreateInputBuffer(DWORD iBufferSize, BYTE* data);
	__declspec(dllexport) HRESULT CreateOutputBuffer(DWORD iBufferSize);

	__declspec(dllexport) int GetOutputBufferFactor();

	ComPtr<IUnknown> spTransformUnk;
	ComPtr<IMFTransform> spTransform;
	ComPtr<IMFMediaType> spInputType;
	ComPtr<IMFMediaType> spOutputType;

	// Buffers
	ComPtr<IMFSample> spInputSample;
	ComPtr<IMFSample> spOutputSample;
	ComPtr<IMFMediaBuffer> spInputBuffer;
	ComPtr<IMFMediaBuffer> spOutputBuffer;
	MFT_OUTPUT_DATA_BUFFER outputDataBuffer = { 0 };

	int oBufferFactor = 1;
	const CLSID CLSID_CResamplerMediaObject = __uuidof(CResamplerMediaObject);
};