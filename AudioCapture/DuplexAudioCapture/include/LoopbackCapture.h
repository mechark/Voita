#pragma once

#include <AudioClient.h>
#include <mmdeviceapi.h>
#include <initguid.h>
#include <guiddef.h>
#include <mfapi.h>
#include <atomic>

#include <wil/com.h>
#include <wrl/implements.h>
#include <wil/result.h>

#include "Common.h"
#include "AudioFile.h"
#include "circular_buffer.h"

using namespace Microsoft::WRL;

class CLoopbackCapture :
    public RuntimeClass< RuntimeClassFlags< ClassicCom >, FtmBase, IActivateAudioInterfaceCompletionHandler >
{
public:
    __declspec(dllexport) CLoopbackCapture(circular_buffer<int16_t> * buffer, std::atomic<bool> * lock);
    __declspec(dllexport) void Init(circular_buffer<int16_t>* iBuffer, std::atomic<bool>* lock);
    __declspec(dllexport) CLoopbackCapture() = default;
    __declspec(dllexport) ~CLoopbackCapture();

    __declspec(dllexport) HRESULT StartCaptureAsync(DWORD processId, bool includeProcessTree, PCWSTR outputFileName);
    __declspec(dllexport) HRESULT StopCaptureAsync();

    METHODASYNCCALLBACK(CLoopbackCapture, StartCapture, OnStartCapture);
    METHODASYNCCALLBACK(CLoopbackCapture, StopCapture, OnStopCapture);
    METHODASYNCCALLBACK(CLoopbackCapture, SampleReady, OnSampleReady);
    METHODASYNCCALLBACK(CLoopbackCapture, FinishCapture, OnFinishCapture);

    // IActivateAudioInterfaceCompletionHandler
    __declspec(dllexport) STDMETHOD(ActivateCompleted)(IActivateAudioInterfaceAsyncOperation* operation);

private:
    // NB: All states >= Initialized will allow some methods
        // to be called successfully on the Audio Client
    enum class DeviceState
    {
        Uninitialized,
        Error,
        Initialized,
        Starting,
        Capturing,
        Stopping,
        Stopped,
    };

    __declspec(dllexport) HRESULT OnStartCapture(IMFAsyncResult* pResult);
    __declspec(dllexport) HRESULT OnStopCapture(IMFAsyncResult* pResult);
    __declspec(dllexport) HRESULT OnFinishCapture(IMFAsyncResult* pResult);
    __declspec(dllexport) HRESULT OnSampleReady(IMFAsyncResult* pResult);

    __declspec(dllexport) HRESULT InitializeLoopbackCapture();
    __declspec(dllexport)HRESULT OnAudioSampleRequested();

    __declspec(dllexport) HRESULT ActivateAudioInterface(DWORD processId, bool includeProcessTree);
    __declspec(dllexport) HRESULT FinishCaptureAsync();

    __declspec(dllexport) HRESULT SetDeviceStateErrorIfFailed(HRESULT hr);

    wil::com_ptr_nothrow<IAudioClient> m_AudioClient;
    WAVEFORMATEX m_CaptureFormat{};
    UINT32 m_BufferFrames = 0;
    wil::com_ptr_nothrow<IAudioCaptureClient> m_AudioCaptureClient;
    wil::com_ptr_nothrow<IMFAsyncResult> m_SampleReadyAsyncResult;
    AudioFile audioFile;

    wil::unique_event_nothrow m_SampleReadyEvent;
    MFWORKITEM_KEY m_SampleReadyKey = 0;
    wil::unique_hfile m_hFile;
    wil::critical_section m_CritSec;
    DWORD m_dwQueueID = 0;
    DWORD m_cbHeaderSize = 0;
    DWORD m_cbDataSize = 0;

    // These two members are used to communicate between the main thread
    // and the ActivateCompleted callback.
    PCWSTR m_outputFileName = nullptr;
    HRESULT m_activateResult = E_UNEXPECTED;

    DeviceState m_DeviceState{ DeviceState::Uninitialized };
    wil::unique_event_nothrow m_hActivateCompleted;
    wil::unique_event_nothrow m_hCaptureStopped;

    circular_buffer<int16_t> * pOBuffer;
    std::atomic<bool> * lock_loopback;
};