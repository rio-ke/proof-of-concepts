const Blockchain = require("./Blockchain");
const Block = require("./Block");

let logCoin = new Blockchain();

console.log("mining logcoin in progress...");
logCoin.addNewBlock(
  new Block(1, "06/04/2022", {
    sender: "Frank Joseph",
    recipient: "LogRocket",
    quantity: 25,
  })
);

logCoin.addNewBlock(
  new Block(2, "08/08/2022", {
    sender: "Paul val",
    recipient: "Young A",
    quantity: 34,
  })
);

logCoin.addNewBlock(
  new Block(3, "13/08/2022", {
    sender: "Elena",
    recipient: "Mary",
    quantity: 34,
  })
);

logCoin.addNewBlock(
  new Block(4, "13/08/2022", {
    sender: "jino",
    recipient: "student",
    quantity: 89,
  })
);

logCoin.addNewBlock(
  new Block(3, "13/08/2022", {
    sender: "gino",
    recipient: "student",
    quantity: 89,
  })
);

console.log(JSON.stringify(logCoin, null, 5));
