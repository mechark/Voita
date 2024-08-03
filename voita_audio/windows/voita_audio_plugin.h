#ifndef FLUTTER_PLUGIN_VOITA_AUDIO_PLUGIN_H_
#define FLUTTER_PLUGIN_VOITA_AUDIO_PLUGIN_H_

#include <flutter/method_channel.h>
#include <flutter/plugin_registrar_windows.h>

#include <flutter/event_channel.h>
#include <memory>

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

  std::unique_ptr<flutter::EventChannel<flutter::EncodableValue>> event_channel_;
  std::unique_ptr<flutter::StreamHandler<flutter::EncodableValue>> stream_handler_;
  std::unique_ptr<flutter::EventSink<flutter::EncodableValue>> event_sink_;
};

}  // namespace voita_audio

#endif  // FLUTTER_PLUGIN_VOITA_AUDIO_PLUGIN_H_
