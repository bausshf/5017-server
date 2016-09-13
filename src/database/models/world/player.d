module conquer.database.models.world.player;

import conquer.database.engine;

/// Table: cq_players
class DbPlayer : DatabaseModel!DbPlayer {
  public:
  uint id;
  uint accountId;
  uint lastClientId;
  @DbNull string name;
  uint serverId;

  this(Row row) {
    super(row);
  }
}
