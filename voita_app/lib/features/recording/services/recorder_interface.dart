abstract class Recorder {
  Future<bool?> get isRecording;
  Future<void> startProcessing();
  void addListener(void Function(List<int>) listener);
  void removeListener(void Function(List<int>) listener);
  Future<void> stopProcessing();
}