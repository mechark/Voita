#include "pch.h"

#include <wrl\implements.h>
#include <wil\com.h>
#include <wil\result.h>
#include <wrl.h>
#include <mfapi.h>

#include "AudioFile.h"

HRESULT AudioFile::CreateWAVFile(WAVEFORMATEX streamFormat, LPCWSTR file) {

	m_hFile.reset(CreateFile(file, GENERIC_WRITE, 0, NULL, CREATE_ALWAYS, FILE_ATTRIBUTE_NORMAL, NULL));
	RETURN_LAST_ERROR_IF(!m_hFile);

	// Create and write the WAV header

		// 1. RIFF chunk descriptor
	DWORD header[] = {
						FCC('RIFF'),        // RIFF header
						0,                  // Total size of WAV (will be filled in later)
						FCC('WAVE'),        // WAVE FourCC
						FCC('fmt '),        // Start of 'fmt ' chunk
						sizeof(streamFormat) // Size of fmt chunk
	};
	DWORD dwBytesWritten = 0;
	RETURN_IF_WIN32_BOOL_FALSE(WriteFile(m_hFile.get(), header, sizeof(header), &dwBytesWritten, NULL));

	m_cbHeaderSize += dwBytesWritten;

	// 2. The fmt sub-chunk
	WI_ASSERT(streamFormat.cbSize == 0);
	RETURN_IF_WIN32_BOOL_FALSE(WriteFile(m_hFile.get(), &streamFormat, sizeof(streamFormat), &dwBytesWritten, NULL));
	m_cbHeaderSize += dwBytesWritten;

	// 3. The data sub-chunk
	DWORD data[] = { FCC('data'), 0 };  // Start of 'data' chunk
	RETURN_IF_WIN32_BOOL_FALSE(WriteFile(m_hFile.get(), data, sizeof(data), &dwBytesWritten, NULL));
	m_cbHeaderSize += dwBytesWritten;

	return S_OK;
}

//
//  FixWAVHeader()
//
//  The size values were not known when we originally wrote the header, so now go through and fix the values
//
HRESULT AudioFile::FixWAVHeader() {
	// Write the size of the 'data' chunk first
	DWORD dwPtr = SetFilePointer(m_hFile.get(), m_cbHeaderSize - sizeof(DWORD), NULL, FILE_BEGIN);
	RETURN_LAST_ERROR_IF(INVALID_SET_FILE_POINTER == dwPtr);

	DWORD dwBytesWritten = 0;
	RETURN_IF_WIN32_BOOL_FALSE(WriteFile(m_hFile.get(), &m_cbDataSize, sizeof(DWORD), &dwBytesWritten, NULL));

	// Write the total file size, minus RIFF chunk and size
	// sizeof(DWORD) == sizeof(FOURCC)
	RETURN_LAST_ERROR_IF(INVALID_SET_FILE_POINTER == SetFilePointer(m_hFile.get(), sizeof(DWORD), NULL, FILE_BEGIN));

	DWORD cbTotalSize = m_cbDataSize + m_cbHeaderSize - 8;
	RETURN_IF_WIN32_BOOL_FALSE(WriteFile(m_hFile.get(), &cbTotalSize, sizeof(DWORD), &dwBytesWritten, NULL));

	RETURN_IF_WIN32_BOOL_FALSE(FlushFileBuffers(m_hFile.get()));

	return S_OK;
}