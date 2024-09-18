import 'dart:io';

import 'package:voita_app/features/recording/services/recorder_interface.dart';
import 'package:voita_app/features/recording/services/recorder_service_mobile.dart';
import 'package:voita_app/features/recording/services/recorder_service_windows.dart';

class VoitaRecorder {
  Recorder _recorder;

  VoitaRecorder(this._recorder) {
    if (Platform.isAndroid || Platform.isIOS) {
      _recorder = _recorder as RecorderServiceMobile;
    }
    else if (Platform.isWindows) {
      _recorder = _recorder as RecorderServiceWindows;
    }
  }

  Recorder get getRecorder {
    return _recorder;
  }
}