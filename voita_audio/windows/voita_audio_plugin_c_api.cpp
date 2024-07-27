#include "include/voita_audio/voita_audio_plugin_c_api.h"

#include <flutter/plugin_registrar_windows.h>

#include "voita_audio_plugin.h"

void VoitaAudioPluginCApiRegisterWithRegistrar(
    FlutterDesktopPluginRegistrarRef registrar) {
  voita_audio::VoitaAudioPlugin::RegisterWithRegistrar(
      flutter::PluginRegistrarManager::GetInstance()
          ->GetRegistrar<flutter::PluginRegistrarWindows>(registrar));
}
