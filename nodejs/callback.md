_main.js_

```js
var mysql = require("mysql");

const sqlConnection = (credentials, query, callback) => {
  let connection = mysql.createConnection(credentials);
  connection.query(query, (error, results) => {
    if (error) {
      callback(error.code);
    } else {
      callback(results);
    }
  });
  connection.end();
};

module.exports = sqlConnection;

```

support.js

```js
let sqlConnection = require("./sqlConnection");
let credentials = require("./mysqlCredentials");

var query = "SELECT 1 + 1 AS solution";

sqlConnection(credentials.readCredentials, query, (results) => {
  if (results) {
    console.log(results);
  }
});


```

