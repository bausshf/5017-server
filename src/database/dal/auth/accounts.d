module conquer.database.dal.auth.accounts;

import conquer.database.engine;
import conquer.database.models;

/**
* Gets an account based on an account name.
* Params:
*   accountName = The account name.
* Returns: The database record model.
*/
auto getAccount(string accountName) {
  auto params = getParams(1);
  params[0] = accountName;

  return MySql.readSingle!DbAccount("SELECT * FROM `cq_accounts` WHERE `account` = ?", params);
}
