#include "voita_audio_plugin.h"

// This must be included before many other Windows headers.
#include <windows.h>

// For getPlatformVersion; remove unless needed for your plugin implementation.
#include <VersionHelpers.h>

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>
#include <flutter/standard_method_codec.h>

#include <memory>
#include <vector>
#include <sstream>
#include <thread>
#include <flutter/event_stream_handler_functions.h>
#include <ProcessManager.h>
#include "AudioRecorder.h"
#include <mutex>

namespace voita_audio {

typedef flutter::EventChannel<flutter::EncodableValue> FlEventChannel;
typedef flutter::StreamHandler<flutter::EncodableValue> FlStreamHandler;
typedef flutter::EventSink<flutter::EncodableValue> FlEventSink;
typedef flutter::StreamHandlerError<flutter::EncodableValue> FlStreamHandlerError;

class AudioRecorderStreamHandler : public FlStreamHandler {
public:
    AudioRecorderStreamHandler(flutter::PluginRegistrarWindows *registrar);
    ~AudioRecorderStreamHandler();

protected:
    std::unique_ptr<FlStreamHandlerError>
    OnListenInternal(const flutter::EncodableValue *arguments,
                   std::unique_ptr<FlEventSink> &&events) override;

    std::unique_ptr<FlStreamHandlerError>
    OnCancelInternal(const flutter::EncodableValue *arguments) override;

private:
    flutter::PluginRegistrarWindows *_registrar = nullptr;
    std::unique_ptr<AudioRecorder> recorder;
    std::unique_ptr<FlEventSink> sink;
    HWND message_window;
    int window_proc_id = -1;
    static const UINT WM_AUDIO_FRAME = WM_USER + 1;

    LRESULT CALLBACK WindowProc(HWND hwnd, UINT uMsg, WPARAM wParam, LPARAM lParam);
    //HWND CreateMessageWindow(HINSTANCE hInstance);
};

LRESULT CALLBACK AudioRecorderStreamHandler::WindowProc(HWND hwnd, UINT uMsg, WPARAM wParam, LPARAM lParam) {
    if (uMsg == WM_AUDIO_FRAME) {
        if (lParam) {
            int32_t* pFrame = reinterpret_cast<int32_t*>(lParam);
            int size = (int) wParam;

            std::vector<int32_t> frame(pFrame, pFrame + size);
            sink->Success(flutter::EncodableValue(frame));
        }
        return 0;
    }
    return DefWindowProc(hwnd, uMsg, wParam, lParam);
}

AudioRecorderStreamHandler::AudioRecorderStreamHandler(flutter::PluginRegistrarWindows *registrar)
    : _registrar(registrar) 
{   
}
/*
HWND AudioRecorderStreamHandler::CreateMessageWindow(HINSTANCE hInstance) {
    const wchar_t CLASS_NAME[] = L"VoitaAudioMessageWindow";

    // WNDCLASS wc = {};
    // wc.lpfnWndProc = WindowProc;
    // wc.hInstance = hInstance;
    // wc.lpszClassName = CLASS_NAME;

    // RegisterClass(&wc);

    // return CreateWindowEx(
    //     0,                              // Optional window styles
    //     CLASS_NAME,                     // Window class
    //     L"VoitaAudioMessageWindow",     // Window text
    //     WS_OVERLAPPEDWINDOW,            // Window style

    //     // Size and position
    //     CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT,

    //     HWND_MESSAGE,                   // Parent window    
    //     NULL,                           // Menu
    //     hInstance,                      // Instance handle
    //     NULL                            // Additional application data
    // );

    HWND h = 0;
    return h;
}
*/
AudioRecorderStreamHandler::~AudioRecorderStreamHandler() {
 _registrar->UnregisterTopLevelWindowProcDelegate(window_proc_id);
}

std::unique_ptr<FlStreamHandlerError> AudioRecorderStreamHandler::OnListenInternal(
    const flutter::EncodableValue *arguments,
    std::unique_ptr<FlEventSink> &&events) 
{
     if (window_proc_id == -1) {
         window_proc_id = _registrar->RegisterTopLevelWindowProcDelegate(
             [this](HWND hWnd, UINT message, WPARAM wParam, LPARAM lParam) {
                 message_window = hWnd;
                 return WindowProc(hWnd, message, wParam, lParam);
             }
         );
     }

     sink = std::move(events);
     ProcessManager processManager;
     recorder = std::make_unique<AudioRecorder>(message_window);

     DWORD processId = processManager.FindProcessByName(L"Firefox.exe");
     recorder->StartRecording(processId, true);

    return nullptr;
}

std::unique_ptr<FlStreamHandlerError> AudioRecorderStreamHandler::OnCancelInternal(const flutter::EncodableValue *arguments)
{
    recorder->StopRecording();
    recorder.release();
    return nullptr;
}

// static
void VoitaAudioPlugin::RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar) {
  registrar->AddPlugin(std::make_unique<VoitaAudioPlugin>(registrar));
}

VoitaAudioPlugin::VoitaAudioPlugin() {}

VoitaAudioPlugin::VoitaAudioPlugin(flutter::PluginRegistrarWindows *registrar)
{
  auto plugin = std::make_unique<VoitaAudioPlugin>();

  event_channel_ = std::make_unique<FlEventChannel>(
    registrar->messenger(), "audio_streaming",
    &flutter::StandardMethodCodec::GetInstance()
  );

  event_channel_->SetStreamHandler(
      std::make_unique<AudioRecorderStreamHandler>(registrar));
}

VoitaAudioPlugin::~VoitaAudioPlugin() {}

}  // namespace voita_audio
