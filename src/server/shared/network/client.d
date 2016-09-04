module conquer.network.client;

import vibe.core.core : runTask;
import vibe.core.task : Task;
import vibe.core.net : TCPConnection;

import conquer.debugging;

/// A tcp client connection for usage with a tcp server.
class Client {
  private:
  /// The tcp connection associated with it.
  TCPConnection _client;
  /// The reader task associated with it.
  Task _readTask;

  public:
  /**
  * Creates a new client.
  * params:
  *   client = The internal tcp client to associated with it.
  */
  this(TCPConnection client) {
    logCall();

    _client = client;
  }

  package(conquer.network) {
    /// Processes the client.
    void process() {
      logCall();

      _readTask = runTask({
        logCall();

        // TODO: More connection validation ...
        while (_client.connected) {
          // TODO: receive data ...
          // TODO: Receive data in parts of 1024 bytes ...
          // TODO: There are 2 receive parts [HEADER (4 bytes)][BODY (size of HEADER[0 .. 1])]
          // TODO: Handle suffixes as well ...
        }
      });

      _readTask.join();

      // If the client is still connected, then we'll force close it ...
      if (_client.connected) {
        _client.close();
      }
    }
  }
}
