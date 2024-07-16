#pragma once

class Merger {
public:
	__declspec(dllexport) void Impose(void* buff1, void* buff2, void* writeBuff);

private:
	int lastFrame = 0;
};