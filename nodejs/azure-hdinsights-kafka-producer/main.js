let express = require("express");
let producerControllerRouter = require("./router/producerController");

let app = express();
app.use(express.json());
app.use("/producerController", producerControllerRouter);

app.get("/", (req, res) => {
  res.send({
    statusCode: 200,
    message: "Event Driven Apps",
  });
});

app.get("/healthz", (req, res) => {
  res.send({
    statusCode: 200,
    message: "Running state",
  });
});

let PORT = process.env.PORT || 9000;

console.log(PORT);
console.log(process.env.KAFKA_HOST);
console.log(process.env.KAFKA_TOPIC);
app.listen(PORT);
