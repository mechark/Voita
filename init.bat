cd AudioCapture/AudioCaptureConsole
msbuild audio-capture.sln
cd ../../

cd voita_audio/windows
mkdir build
cmake -S . -B build