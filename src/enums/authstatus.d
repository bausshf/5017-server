module conquer.enums.authstatus;

/// Enumeration for auth status.
enum AuthStatus : uint {
  /// Error.
	error,
  /// Invalid account or password.
	invalidAccountOrPassword,
  /// Ready.
  ready
}
