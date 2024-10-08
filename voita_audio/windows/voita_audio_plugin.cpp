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
    std::unordered_map<std::string, PCWSTR> AVAILABLE_PROCESSES;
    std::string processName;

    static LRESULT CALLBACK WindowProc(HWND hwnd, UINT uMsg, WPARAM wParam, LPARAM lParam);
    HWND CreateMessageWindow(HINSTANCE hInstance);

    std::unique_ptr<flutter::MethodChannel<flutter::EncodableValue>> method_channel;
};

// static
LRESULT CALLBACK AudioRecorderStreamHandler::WindowProc(HWND hwnd, UINT uMsg, WPARAM wParam, LPARAM lParam) {
    if (uMsg == WM_AUDIO_FRAME) {
        AudioRecorderStreamHandler * pStreamHandler = reinterpret_cast<AudioRecorderStreamHandler*>(GetWindowLongPtrW(hwnd, 0));

        if (pStreamHandler->sink) {
            int32_t* pFrame = reinterpret_cast<int32_t*>(lParam);
            int size = (int)wParam;

            std::vector<int32_t> frame(pFrame, pFrame + size);
            pStreamHandler->sink->Success(flutter::EncodableValue(frame));
        }

        return 0;
    }
    return DefWindowProc(hwnd, uMsg, wParam, lParam);
}

AudioRecorderStreamHandler::AudioRecorderStreamHandler(flutter::PluginRegistrarWindows *registrar)
    : _registrar(registrar) 
{   
    method_channel = std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(
      registrar->messenger(), "set_process_name",   
      &flutter::StandardMethodCodec::GetInstance());

    method_channel->SetMethodCallHandler(
        [this](const flutter::MethodCall<>& call, std::unique_ptr<flutter::MethodResult<>> result) {

            if (call.method_name().compare("set_process_name") == 0) {
                const std::string* procName = std::get_if<std::string>(call.arguments());
                this->processName = *procName;
                result->Success(flutter::EncodableValue(*procName));
            }
            else {
                result->NotImplemented();
            }
        });

    HINSTANCE hInstance = GetModuleHandle(NULL);
    message_window = CreateMessageWindow(hInstance);

    // Pass this to the static WindowProc 
    SetWindowLongPtrW(message_window, 0, reinterpret_cast<LONG_PTR>(this));

    AVAILABLE_PROCESSES = {
        {"Firefox", L"Firefox.exe"},
        {"Chrome", L"Chrome.exe"},
        {"Zoom", L"Zoom.exe"},
        {"Microsoft Teams", L"ms-teams.exe"}
    };

    //processName = AVAILABLE_PROCESSES["Zoom"];
}

HWND AudioRecorderStreamHandler::CreateMessageWindow(HINSTANCE hInstance) {
    LPCSTR CLASS_NAME = "VoitaAudioMessageWindow";

    WNDCLASSA wc = {};
    wc.lpfnWndProc = WindowProc;
    wc.hInstance = hInstance;
    wc.lpszClassName = CLASS_NAME;
    wc.cbWndExtra  = sizeof(AudioRecorderStreamHandler*);

    RegisterClassA(&wc);

    return CreateWindowExA(
        0,                              
        CLASS_NAME,                     
        CLASS_NAME,     
        WS_OVERLAPPEDWINDOW,            
        // Size and position
        CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT, CW_USEDEFAULT,
        HWND_MESSAGE,                   // Parent window    
        NULL,                           // Menu
        hInstance,                      // Instance handle
        NULL                            // Additional application data
    );

   return message_window;
}

AudioRecorderStreamHandler::~AudioRecorderStreamHandler() {
    sink.release();
}

std::unique_ptr<FlStreamHandlerError> AudioRecorderStreamHandler::OnListenInternal(
    const flutter::EncodableValue *arguments,
    std::unique_ptr<FlEventSink> &&events) 
{
    sink = std::move(events);
    ProcessManager processManager;
    DWORD processId = processManager.FindProcessByName(L"explorer.exe");
    recorder = std::make_unique<AudioRecorder>(message_window);
        
    if (AVAILABLE_PROCESSES.count(processName) != 0) {
        processId = processManager.FindProcessByName(AVAILABLE_PROCESSES[processName]);
    }

    recorder->StartRecording(0, true);

    return nullptr;
}

std::unique_ptr<FlStreamHandlerError> AudioRecorderStreamHandler::OnCancelInternal(const flutter::EncodableValue *arguments)
{
    // if (message_window != NULL) {
    //     DestroyWindow(message_window);
    // }
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
