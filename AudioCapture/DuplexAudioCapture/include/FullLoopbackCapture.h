#pragma once
#include "LoopBack.h"
#include <winnt.h>
#include <wtypes.h>

#include "circular_buffer.h"
#include <AudioFile.h>
#include <mmdeviceapi.h>
#include <Audioclient.h>
#include <thread>

#define BUSY_DEVICE_ERROR 0x88890010

class FullLoopbackCapture : public LoopBack {
public:
	__declspec(dllexport) FullLoopbackCapture() = default;
	__declspec(dllexport) HRESULT StartCaptureAsync(DWORD processId, bool includeProcessTree, PCWSTR file = L"output.wav") override;
	__declspec(dllexport) HRESULT FinishCapture();
	__declspec(dllexport) HRESULT ActivateAudioClient();
	__declspec(dllexport) void Init(circular_buffer<int16_t>* iBuffer, HANDLE* capture_event) override;

private:
	const CLSID CLSID_MMDeviceEnumerator = __uuidof(MMDeviceEnumerator);
	const IID IID_IMMDeviceEnumerator = __uuidof(IMMDeviceEnumerator);
	const IID IID_IAudioClient = __uuidof(IAudioClient);
	const IID IID_IAudioCaptureClient = __uuidof(IAudioCaptureClient);

	HRESULT hr;
	IMMDeviceEnumerator* pEnum = NULL;
	IMMDevice* pDevice = NULL;
	IAudioClient* pAudioClient = NULL;
	REFERENCE_TIME hnsBufferDuration = 1000000;
	REFERENCE_TIME hnsPeriodicity = 1000;
	UINT32 bufferFrameCount = 0;
	IAudioCaptureClient* pCaptureClient = NULL;
	REFERENCE_TIME hnsActualDuration = 0;
	BOOL isDone = FALSE;
	UINT32 numFramesInNextPacket = 0;
	BYTE* nextDataPacketAddr;
	UINT32 numFramesAvailable;
	DWORD flags;
	WAVEFORMATEX* pStreamFormat;
	AudioFile audioFile;
	std::thread m_captureThread;

	circular_buffer<int16_t>* pIBuffer;

	HANDLE* captured_event;

	__declspec(dllexport) HRESULT OnSampleReady();
	__declspec(dllexport) HRESULT OnStartCapture();
	__declspec(dllexport) HRESULT OnFinishCapture();
};