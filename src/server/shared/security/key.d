module conquer.security.key;

/// Wrapper around a key incrementer;
struct Key(T) {
  private:
  /// The key.
  T _key;

  public:
  @property {
    /// Gets the key.
    immutable(T) key() pure nothrow @nogc @safe { return _key; }
  }

  /// Aliasing the key property directly to the struct.
  alias key this;

  /// Increments the key.
  void increment() pure nothrow @nogc @safe {
    _key++;
  }
}
