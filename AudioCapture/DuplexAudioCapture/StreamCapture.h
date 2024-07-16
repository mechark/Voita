#pragma once
#include <thread>

#include "AudioFile.h"

class StreamCapture {
	public:
		__declspec(dllexport) void StartCaptureAsync(LPCWSTR file);
		__declspec(dllexport) HRESULT FinishCapture();
		__declspec(dllexport) HRESULT ActivateAudioClient();

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

		__declspec(dllexport) HRESULT OnSampleReady();
		__declspec(dllexport) void OnStartCapture();
		__declspec(dllexport) HRESULT OnFinishCapture();
};