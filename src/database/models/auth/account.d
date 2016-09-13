module conquer.database.models.auth.account;

import conquer.database.engine;

/// Table: cq_accounts
class DbAccount : DatabaseModel!DbAccount {
  public:
  uint id;
  string account;
  string password;
  string salt;
  string registrationEmail;
  string currentEmail;
  string firstName;
  @DbNull string middleName;
  string lastName;
  string country;
  string registrationIP;
  @DbNull string firstLoginIP;
  @DbNull string lastLoginIP;
  DateTime registrationDate;
  bool deleted;
  @DbNull DateTime deletedDate;
  bool banned;
  @DbNull DateTime bannedDate;
  @DbNull DateTime unbanDate;
  @DbNull string banReason;

  this(Row row) {
    super(row);
  }
}
