#pragma once
#include <thread>

#include "AudioFile.h"
#include "StreamMerger.h"
#include "circular_buffer.h"

class StreamCapture {
	public:
		__declspec(dllexport) StreamCapture(circular_buffer<int16_t>* iBuffer, std::atomic<bool> * lock);
		__declspec(dllexport) StreamCapture() = default;
		__declspec(dllexport) HRESULT StartCaptureAsync(LPCWSTR file);
		__declspec(dllexport) HRESULT FinishCapture();
		__declspec(dllexport) HRESULT ActivateAudioClient();
		__declspec(dllexport) void Init(circular_buffer<int16_t>* iBuffer, std::atomic<bool>* lock);

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
		StreamMerger streamMerger;
		std::thread m_captureThread;

		std::atomic<bool> * lock;
		circular_buffer<int16_t> * pIBuffer;

		__declspec(dllexport) HRESULT OnSampleReady();
		__declspec(dllexport) HRESULT OnStartCapture();
		__declspec(dllexport) HRESULT OnFinishCapture();
};