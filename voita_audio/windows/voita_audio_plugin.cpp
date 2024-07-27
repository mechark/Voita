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
#include <FullDuplexAudioRecorder.h>

namespace voita_audio {

typedef flutter::EventChannel<flutter::EncodableValue> FlEventChannel;
typedef flutter::StreamHandler<flutter::EncodableValue> FlStreamHandler;
typedef flutter::EventSink<flutter::EncodableValue> FlEventSink;
typedef flutter::StreamHandlerError<flutter::EncodableValue> FlStreamHandlerError;

class AudioRecorderStreamHandler : public FlStreamHandler {
public:
    AudioRecorderStreamHandler(flutter::PluginRegistrarWindows *registrar);

protected:
    std::unique_ptr<FlStreamHandlerError>
    OnListenInternal(const flutter::EncodableValue *arguments,
                   std::unique_ptr<FlEventSink> &&events) override;

    std::unique_ptr<FlStreamHandlerError>
    OnCancelInternal(const flutter::EncodableValue *arguments) override;

private:
    flutter::PluginRegistrarWindows *_registrar = nullptr;
    std::unique_ptr<FlEventSink> sink;
};

AudioRecorderStreamHandler::AudioRecorderStreamHandler(flutter::PluginRegistrarWindows *registrar)
    : _registrar(registrar) {}

std::unique_ptr<FlStreamHandlerError> AudioRecorderStreamHandler::OnListenInternal(
    const flutter::EncodableValue *arguments,
    std::unique_ptr<FlEventSink> &&events) 
{
    sink = std::move(events);

    while (sink)
    {
        FullDuplexAudioRecorder recorder;
        std::vector<int32_t> audioFrame(100);
        for (int i = 0; i < 100; i++) {
            audioFrame[i] = i; 
        }
    
        sink->Success(flutter::EncodableValue(audioFrame));
    }

    return nullptr;
}


std::unique_ptr<FlStreamHandlerError> AudioRecorderStreamHandler::OnCancelInternal(const flutter::EncodableValue *arguments)
{
    _registrar->UnregisterTopLevelWindowProcDelegate(-1);
    sink.reset();
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

  auto channel = 
  std::make_unique<flutter::MethodChannel<flutter::EncodableValue>>(registrar->messenger(), "voita_audio",
          &flutter::StandardMethodCodec::GetInstance());

  channel->SetMethodCallHandler(
      [plugin_pointer = plugin.get()](const auto &call, auto result) {
        plugin_pointer->HandleMethodCall(call, std::move(result));
      });

  event_channel_ = std::make_unique<FlEventChannel>(
    registrar->messenger(), "audio_streaming",
    &flutter::StandardMethodCodec::GetInstance()
  );

  event_channel_->SetStreamHandler(
      std::make_unique<AudioRecorderStreamHandler>(registrar));

}

VoitaAudioPlugin::~VoitaAudioPlugin() {}

void VoitaAudioPlugin::HandleMethodCall(
    const flutter::MethodCall<flutter::EncodableValue> &method_call,
    std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result) {
  if (method_call.method_name().compare("getPlatformVersion") == 0) {
    std::ostringstream version_stream;
    version_stream << "Windows fuck ";
    if (IsWindows10OrGreater()) {
      version_stream << "10+";
    } else if (IsWindows8OrGreater()) {
      version_stream << "8";
    } else if (IsWindows7OrGreater()) {
      version_stream << "7";
    }
    result->Success(flutter::EncodableValue(version_stream.str()));
  }
  else {
    std::cout << "Here?" << std::endl;
    result->NotImplemented();
  }
}

}  // namespace voita_audio