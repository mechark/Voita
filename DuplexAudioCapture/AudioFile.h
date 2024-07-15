#pragma once
#include "pch.h"

#include <wrl\implements.h>
#include <wil\com.h>
#include <wil\result.h>

using namespace Microsoft::WRL;

class AudioFile {
public:
	__declspec(dllexport) HRESULT CreateWAVFile(WAVEFORMATEX streamFormat, LPCWSTR file);
	__declspec(dllexport) HRESULT FixWAVHeader();

	DWORD m_cbHeaderSize = 0;
	DWORD m_cbDataSize = 0;
	wil::unique_hfile m_hFile;
 };