module conquer.security.auth.rc5;

import conquer.network.networkpacket;

/// Wrapper to write the data for the RC5 cryptography dynamically.
private class RC5Data : NetworkPacket {
  /// Creates a new RC5 data wrapper.
  this() {
    super();
  }
}

private {
  /// The RC5 encryption keys.
  enum keys = [
    0xEBE854BC, 0xB04998F7, 0xFFFAA88C, 0x96E854BB,
    0xA9915556, 0x48E44110, 0x9F32308F, 0x27F41D3E,
    0xCF4F3523, 0xEAC3C6B4, 0xE9EA5E03, 0xE5974BBA,
    0x334D7692, 0x2C6BCF2E, 0xDC53B74,  0x995C92A6,
    0x7E4F6D77, 0x1EB2B79F, 0x1D348D89, 0xED641354,
    0x15E04A9D, 0x488DA159, 0x647817D3, 0x8CA0BC20,
    0x9264F7FE, 0x91E78C6C, 0x5C9A07FB, 0xABD4DCCE,
    0x6416F98D, 0x6642AB5B
  ];

  /**
  *	Rotates the bits right.
  *	Params:
  *		dwVar =		DWORD value to rotate
  *		dwOffset =	DWORD offset to rotate.
  *	Returns: The rotated value.
  */
  uint rightRotate(uint dwVar, uint dwOffset) {
    uint dwTemp1, dwTemp2;

    dwOffset = dwOffset & 0x1F;
    dwTemp1 = dwVar << cast(int)(32 - dwOffset);
    dwTemp2 = dwVar >> cast(int)dwOffset;
    dwTemp2 = dwTemp2 | dwTemp1;

    return dwTemp2;
  }
}

/**
* Decrypts a buffer using the RC5 cryptography.
* Params:
*   buffer = The buffer to decrypt.
* Returns: The decrypted buffer as a string.
*/
string decryptRc5(ubyte[] buffer) {
  auto rc5 = new RC5Data;
  rc5.writeBuffer(buffer);

  auto passInts = new uint[4];

  foreach (ref passInt; passInts) {
      passInt = rc5.read!uint;
  }

  uint temp1, temp2;

  for (int i = 1; i >= 0; i--) {
    temp1 = passInts[(i * 2) + 1];
    temp2 = passInts[i * 2];

    for (int j = 11; j >= 0; j--) {
      temp1 = rightRotate(temp1 - keys[j * 2 + 7], temp2) ^ temp2;
      temp2 = rightRotate(temp2 - keys[j * 2 + 6], temp1) ^ temp1;
    }

    passInts[i * 2 + 1] = temp1 - keys[5];
    passInts[i * 2] = temp2 - keys[4];
  }

  rc5.resetWrite();
  rc5.resetRead();

  foreach (passInt; passInts) {
      rc5.write!uint(passInt);
  }

  return rc5.readString(16);
}
