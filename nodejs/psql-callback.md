**psql callback**

```js
const { Pool } = require("pg");

const psqlDbConnection = (
  user = "jino",
  password = "mysecretpassword",
  database = "jino",
  host = "localhost",
  port = 5432
) => {
  return (pool = new Pool({
    user,
    host,
    database,
    password,
    port,
  }));
};

const psqlDbQuery = (credential, query, callback) => {
  credential.query(query, (error, results) => {
    if (error) callback(psqlErrorHandler(error), null);
    else callback(null, results);
    pool.end();
  });
};

psqlErrorHandler = (error) => {
  let code = error.code;
  let severity = error.severity;
  let routine = error.routine;
  if ((routine == "auth_failed")) return { errorMessage:  "Something is wrong with the username or password or hostname or port" };
  else if ((routine == "InitPostgres")) return { errorMessage: "Something is wrong with db." };
  else if ((routine == "ParseFuncOrColumn")) return { errorMessage: "Error with the default function in Psql" };
  else if (routine != "auth_failed" && routine != "InitPostgres" && routine == "ParseFuncOrColumn") return { code, severity, routine };
  else return null;
};

psqlDbQuery(psqlDbConnection(), "SELECT * from NOW()", (err, results) => {
  if (err) console.log(err);
  if (results) console.log(results);
});

```