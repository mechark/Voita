#pragma once
#include "pch.h"

#include <wtypes.h>
#include <iostream>

template <class T>
class circular_buffer {

public:
	explicit circular_buffer(size_t bufferSize) : 
		buffer(std::unique_ptr<T[]>(new T[bufferSize])), buffSize (bufferSize)
	{
	}

	void push(T * data, size_t count = 1)
	{
		for (size_t i = 0; i < count; i++)
		{
			buffer[head] = data[i];
			head = (head + 1) % buffSize;
		}
	}

	void push(BYTE * data, size_t count = 1)
	{
		lastFrameSize = count;
		for (size_t i = 0; i < count; i++)
		{
			BYTE* newData = data + i * sizeof(T);
			buffer[head] = readFromBytes<T>(newData);
			head = (head + 1) % buffSize;
		}
	}

	T read()
	{
		tail = (tail + 1) % buffSize;
		return buffer[tail];
	}

	int size()
	{
		//if (head >= tail) return head - tail;
		return buffSize - head + tail;
	}

	int getFrameSize()
	{
		return lastFrameSize;
	}

private:
	size_t buffSize;
	size_t head = 0;
	size_t tail = 0;
	size_t lastFrameSize = 0;

	std::unique_ptr<T[]> buffer;

	template<typename T>
	T readFromBytes(BYTE* byteAddress, size_t offset = 0) {
		return *reinterpret_cast<const T*>(byteAddress + offset);
	}
};