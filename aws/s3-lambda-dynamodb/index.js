"use strict";
exports.handler = function (event, context, callback) {
  var response = {
    headers: {
      "Content-Type": "text/html; charset=utf-8",
    },
    statusCode: 200,
    body: "<h1>Welcome to AWS API GATEWAY!!!</h1>",
  };
  callback(null, response);
};
