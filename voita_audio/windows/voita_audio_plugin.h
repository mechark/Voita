#ifndef FLUTTER_PLUGIN_VOITA_AUDIO_PLUGIN_H_
#define FLUTTER_PLUGIN_VOITA_AUDIO_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <memory>
#include <flutter/event_channel.h>

namespace voita_audio {

class VoitaAudioPlugin : public flutter::Plugin {
 public:
  static void RegisterWithRegistrar(flutter::PluginRegistrarWindows *registrar);

  VoitaAudioPlugin();
  VoitaAudioPlugin(flutter::PluginRegistrarWindows *registrar);

  virtual ~VoitaAudioPlugin();

  // Disallow copy and assign.
  VoitaAudioPlugin(const VoitaAudioPlugin&) = delete;
  VoitaAudioPlugin& operator=(const VoitaAudioPlugin&) = delete;

  // Called when a method is called on this plugin's channel from Dart.
  void HandleMethodCall(
      const flutter::MethodCall<flutter::EncodableValue> &method_call,
      std::unique_ptr<flutter::MethodResult<flutter::EncodableValue>> result);

  std::unique_ptr<flutter::EventChannel<flutter::EncodableValue>> event_channel_;
  std::unique_ptr<flutter::StreamHandler<flutter::EncodableValue>> stream_handler_;
  std::unique_ptr<flutter::EventSink<flutter::EncodableValue>> event_sink_;

  // EventChannel callbacks
  std::unique_ptr<flutter::StreamHandler<flutter::EncodableValue>> GetStreamHandler();
  void OnListen(std::unique_ptr<flutter::EventSink<flutter::EncodableValue>>&& events);
  void OnCancel();

};

}  // namespace voita_audio

#endif  // FLUTTER_PLUGIN_VOITA_AUDIO_PLUGIN_H_
