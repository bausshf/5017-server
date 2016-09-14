module conquer.database.dal.auth.accounts;

import conquer.database.engine;
import conquer.database.models;
import conquer.enums;

/**
* Gets an account based on an account name.
* Params:
*   accountName = The account name.
* Returns: The database record model.
*/
auto getAccount(inout(string) accountName) {
  enum sql = "SELECT * FROM `cq_accounts` WHERE `account` = ?";
  auto params = getParams(1);
  params[0] = accountName;

  return MySql.readSingle!DbAccount(sql, params);
}

/**
* Authenticates a user.
* Params:
*   accountName = The account name.
*   password = The password.
*/
auto authenticate(inout(string) accountName, inout(string) password, out uint accountId) {
  auto account = getAccount(accountName);
  accountId = 0;

  // TODO: hash passwords ...

  if (!account || account.password != password) {
    return AuthStatus.error; // TODO: figure out why invalidAccountOrPassword doesn't work.
  }

  accountId = account.id;

  // TODO: validate bans

  return AuthStatus.ready;
}
