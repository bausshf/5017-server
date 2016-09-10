module conquer.security.cryptographer;

/// Wrapper for a cryptographer.
abstract class Cryptographer {
    package(conquer.security):
    /// Creates a new cryptographer.
    this() {}

    public:
    /**
    * Encrypts a buffer.
    * Params:
    *   buffer = The buffer to encrypt.
    */
    abstract void encrypt(ubyte[] buffer);

    /**
    * Decrypts a buffer.
    * Params:
    *   buffer = The buffer to decrypt.
    */
    abstract void decrypt(ubyte[] buffer);
}
