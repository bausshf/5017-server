module conquer.network.networkpacket;

import std.array : replace;

import conquer.core.mathematics : max;
import conquer.errors;

/// Wrapper around a network packet.
class NetworkPacket {
  private:
  /// The buffer.
  ubyte[] _buffer;
  /// The read offset.
  size_t _readOffset;
  /// The write offset.
  size_t _writeOffset;

  public:
  /**
  * Creates a new network packet.
  * Params:
  *   buffer =  The buffer.
  *   offset =  The offset.
  */
  this(ubyte[] buffer, size_t offset = 4) {
    _buffer = buffer;
    _readOffset = max(offset, 0);
  }

  /**
  * Creates a new network packet.
  * Params:
  *   size =  The size.
  *   type =  The type.
  */
  this(size_t size, ushort type) {
    this(cast(ushort)size, type);
  }

  /**
  * Creates a new network packet.
  * Params:
  *   size =  The size.
  *   type =  The type.
  */
  this(ushort size, ushort type) {
    _buffer = new ubyte[size];

    write(size);
    write(type);
  }

  /// Creates a new network packet.
  this() {
    _buffer = new ubyte[0];
  }

  /*
  * Reads a value.
  * Returns: The value.
  */
  auto read(T)() {
    if (_readOffset >= _buffer.length) {
      throw new OutOfRangeException(_buffer.stringof, _readOffset);
    }

    static if (is(T == bool)) {
      return read!ubyte > 0;
    }
    else {
      auto value = (*cast(T*)(_buffer.ptr + _readOffset));

      _readOffset += T.sizeof;

      return value;
    }
  }

  /*
  * Reads a value.
  * Params:
  *   offset =  The offset.
  * Returns: The value.
  */
  auto read(T)(size_t offset) {
    static if (is(T == bool)) {
      return read!ubyte(offset) > 0;
    }
    else static if (is(T == string)) {
      return readStringOffset(offset);
    }
    else {
      return (*cast(T*)(_buffer.ptr + offset));
    }
  }

  /**
  * Reads a buffer.
  * Params:
  *   size =  The size.
  * Returns: The buffer.
  */
  auto readBuffer(size_t size) {
    auto index = _readOffset + size;

    if (index > _buffer.length) {
      throw new OutOfRangeException(_buffer.stringof, index);
    }

    auto value = _buffer[_readOffset .. index];
    _readOffset += size;
    return value;
  }

  /**
  * Reads a buffer.
  * Params:
  *   size =    The size.
  *   offset =  The offset.
  * Returns: The buffer.
  */
  auto readBuffer(size_t size, size_t offset) {
    auto index = offset + size;

    if (index > _buffer.length) {
      throw new OutOfRangeException(_buffer.stringof, index);
    }

    return _buffer[offset .. index];
  }

  /**
  * Reads a string.
  * Params:
  *   size =  The size.
  * Returns: The size.
  */
  auto readString(size_t size) {
    auto value = cast(string)readBuffer(size);

    return value.replace("\0", "");
  }

  /**
  * Reads a string.
  * Returns: The string.
  */
  auto readString() {
    auto size = read!ubyte;

    return readString(size);
  }

  /**
  * Reads a range of strings.
  * Returns: The range of strings.
  */
  auto readStrings() {
    string[] values;

    auto amount = read!ubyte;

    foreach (i; 0 .. amount) {
      values ~= readString();
    }

    return values;
  }

  /**
  * Reads a string.
  * Params:
  *   size =    The size.
  *   offset =  The offset.
  * Returns: The string.
  */
  auto readString(size_t size, size_t offset) {
    auto value = cast(string)readBuffer(size, offset);

    return value.replace("\0", "");
  }

  /**
  * Reads a string by an offset.
  * Params:
  *   offset = The offset.
  * Returns: The string.
  */
  auto readStringOffset(size_t offset) {
    auto size = read!ubyte;
    offset++;

    return readString(size, offset);
  }

  /**
  * Reads a range of strings.
  * Params:
  *   offset =  The offset.
  * Returns: The range of strings.
  */
  auto readStrings(size_t offset) {
    string[] values;

    auto amount = read!ubyte(offset);
    offset++;

    foreach (i; 0 .. amount) {
      auto value = readStringOffset(offset);
      offset += value.length + 1;
      values ~= value;
    }

    return values;
  }

  /**
  * Writes a value.
  * Params:
  *   value = The value.
  */
  void write(T)(inout(T) value) {
    static if (is(T == bool)) {
      write!ubyte(value ? 1 : 0);
    }
    else {
      if (_writeOffset >= _buffer.length) {
        _buffer.length += ((_buffer.length + T.sizeof) * 2);
      }

      (*cast(T*)(_buffer.ptr + _writeOffset)) = value;

      _writeOffset += T.sizeof;
    }
  }

  /**
  * Writes a value.
  * Params:
  *   value =   The value.
  *   offset =  The offset.
  */
  void write(T)(inout(T) value, size_t offset) {
    if (offset >= _buffer.length) {
      throw new OutOfRangeException(_buffer.stringof, offset);
    }

    (*cast(T*)(_buffer.ptr + offset)) = value;
  }

  /**
  * Writes a buffer.
  * Params:
  *   buffer = The buffer.
  */
  void writeBuffer(inout(ubyte[]) buffer) {
    // TODO: append directly ...

    foreach (entry; buffer) {
      write(entry);
    }
  }

  /**
  * Writes a buffer.
  * Params:
  *   buffer = The buffer.
  *   offset = The offset.
  */
  void writeBuffer(inout(ubyte[]) buffer, size_t offset) {
    foreach (entry; buffer) {
      write(entry, offset);
    }
  }

  /**
  * Writes a string.
  * Params:
  *   value = The value.
  */
  void writeString(bool isDynamic)(inout(string) value) {
    static if (isDynamic) {
      write(cast(ubyte)value.length);
    }

    foreach (entry; value) {
      write(cast(ubyte)entry);
    }
  }

  /**
  * Writes a range of strings.
  * Params:
  *   values =  The range of strings.
  */
  void writeStrings(inout(string[]) values) {
    write(cast(ubyte)values.length);

    foreach (value; values) {
      writeString!true(value);
    }
  }

  /**
  * Writes a string.
  * Params:
  *   value =   The value.
  *   offset =  The offset.
  */
  void writeString(bool isDynamic)(inout(string) value, size_t offset) {
    static if (isDynamic) {
      write(cast(ubyte)value.length, offset);
      offset++;
    }

    foreach (entry; value) {
      write(cast(ubyte)entry, offset);
      offset++;
    }
  }

  /**
  * Writes a range of strings.
  * Params:
  *   values =   The range of strings.
  *   offset =  The offset.
  */
  void writeStrings(inout(string[]) values, size_t offset) {
    write(cast(ubyte)values.length);
    offset++;

    foreach (value; values) {
      writeString!true(value);
      offset += value.length + 1;
    }
  }

  /**
  * Writes empty bytes until a specific offset.
  * Params:
  *   offset = The offset to reach.
  */
  void writeUntil(size_t offset) {
    if (offset < _writeOffset) {
      throw new OutOfRangeException(_buffer.stringof, offset);
    }

    while (_writeOffset < offset) {
      write!ubyte(0);
    }
  }

  /// Resets the read offset.
  void resetRead() {
    _readOffset = 0;
  }

  /// Resets the write offset.
  void resetWrite() {
    _writeOffset = 0;
  }

  /**
  * Seeks the read offset.
  * Params:
  *   newOffset =   The new offset.
  */
  void seekRead(size_t newOffset) {
    if (newOffset < 0 || newOffset > _buffer.length) {
      throw new OutOfRangeException(_buffer.stringof, newOffset);
    }

    _readOffset = newOffset;
  }

  /**
  * Seeks the write offset.
  * Params:
  *   newOffset =   The new offset.
  */
  void seekWrite(size_t newOffset) {
    if (newOffset < 0 || newOffset > _buffer.length) {
      throw new OutOfRangeException(_buffer.stringof, newOffset);
    }

    _writeOffset = newOffset;
  }

  /// Finalizes the buffer.
  @property ubyte[] finalize() {
    if (_writeOffset > 0 && _buffer.length > _writeOffset) {
      _buffer = _buffer[0 .. _writeOffset];
    }

    write!ushort(cast(ushort)_buffer.length, 0);

    return _buffer.dup;
  }
}
