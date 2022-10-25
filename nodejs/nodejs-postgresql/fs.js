var fs = require("fs");

const readTheContentFromFile = (pathLocation) => {
  data = fs.readFileSync(pathLocation);
  return data.toString();
};

module.exports = readTheContentFromFile;
