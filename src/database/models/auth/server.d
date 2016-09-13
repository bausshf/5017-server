module conquer.database.models.auth.server;
import conquer.database.engine;

/// Table: cq_servers
class DbServer : DatabaseModel!DbServer {
  public:
  uint id;
  string name;
  string ip;
  ushort port;

  this(Row row) {
    super(row);
  }
}
