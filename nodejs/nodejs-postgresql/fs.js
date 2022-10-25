var fs = require("fs");

const readTheContentFromFile = (pathLocation) => {
  return fs.readFileSync(pathLocation).toString();
};

module.exports = readTheContentFromFile;
