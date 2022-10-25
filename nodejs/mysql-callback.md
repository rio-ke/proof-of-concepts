**_requirements_**

```bash
node --version
npm i mysql
```

**_docker mysql service_**

```bash
docker run -d --name mysql -p 3306:3306 -e MYSQL_ROOT_PASSWORD=. mysql:5.7
```

**_sqlConnection.js_**

```js
var mysql = require("mysql");

const sqlConnection = (credentials, query, callback) => {
  let connection = mysql.createConnection(credentials);
  connection.query(query, (error, results, fields) => {
    if (error) {
      callback(
        {
          code: error.code,
          errno: error.errno,
          sqlMessage: error.sqlMessage,
          sqlState: error.sqlState,
        },
        null
      );
    } else {
      callback(null, { results, fields });
    }
  });
  connection.end();
};
module.exports = sqlConnection;



```

**_mysqlCredentials.js_**

```js
var readCredentials = {
  host: "localhost",
  user: "root",
  password: ".",
  database: "mysql",
  port: 3306
};

var writeCredentials = {
  host: "localhost",
  user: "root",
  password: ".",
  database: "mysql",
  port: 3306
};

module.exports = {
  readCredentials,
  writeCredentials,
};
```

**_support.js_**

```js
let sqlConnection = require("./sqlConnection");
let credentials = require("./mysqlCredentials");

var query = "SELECT 1 + 1 AS solution";
sqlConnection(credentials.readCredentials, query, (err, results) => {
  if (err) {
    console.log(err);
  } else {
    console.log(results);
  }
});
```
