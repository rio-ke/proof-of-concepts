const express = require("express");
const { psqlDbConnection, psqlDbQuery } = require("./db");
const readTheContentFromFile = require("./fs");

const app = express();
app.use(express.json());

const usernameFile = process.env.USERNAME || "username";
const databaseFile = process.env.DATABASE || "database";
const passwordFile = process.env.PASSWORD || "password";

const username = readTheContentFromFile(usernameFile);
const database = readTheContentFromFile(databaseFile);
const password = readTheContentFromFile(passwordFile);

psqlDbConnectionCredential = psqlDbConnection(username, password, database);

app.get("/", (req, res) => {
  res.send({
    status: "Success",
    message: "Hello API",
  });
});

app.get("/dbconnection", (req, res) => {
  psqlDbQuery(psqlDbConnectionCredential, "SELECT NOW()", (err, results) => {
    if (err)
      res.send({
        status: "Failure",
        message: err,
      });
    if (results)
      res.send({
        status: "Success",
        message: results,
      });
  });
});

app.listen(9000, () => console.log("Express running on 9000"));
