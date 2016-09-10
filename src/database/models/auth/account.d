module conquer.database.models.auth.account;

import conquer.database.engine;

/// Table: cq_accounts
class DbAccount : DatabaseModel {
  public:
  uint id;
  string account;
  string password;
  string salt;
  string registrationEmail;
  string currentEmail;
  string firstName;
  string middleName;
  string lastName;
  string country;
  string registrationIP;
  string firstLoginIP;
  string lastLoginIP;
  DateTime registrationDate;
  bool deleted;
  DateTime deletedDate;
  bool banned;
  DateTime bannedDate;
  DateTime unbanDate;
  string banReason;

  this(Row row) {
    super(row);
  }

  override void fill() {
    id = retrieve!uint;
    account = retrieve!string;
    password = retrieve!string;
    salt = retrieve!string;
    registrationEmail = retrieve!string;
    currentEmail = retrieve!string;
    firstName = retrieve!string;
    middleName = retrieve!(string, true);
    lastName = retrieve!string;
    country = retrieve!string;
    registrationIP = retrieve!string;
    firstLoginIP = retrieve!(string, true);
    lastLoginIP = retrieve!(string, true);
    registrationDate = retrieve!DateTime;
    deleted = retrieve!bool;
    deletedDate = retrieve!(DateTime, true);
    banned = retrieve!bool;
    bannedDate = retrieve!(DateTime, true);
    unbanDate = retrieve!(DateTime, true);
    banReason = retrieve!(string, true);
  }
}
