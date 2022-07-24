const kafka = require("kafka-node");
const kafkaConfig = require("./configuration/kafkaConfig");

const consumerController = () => {
  var topic = kafkaConfig.KAFKA_TOPIC;
  var brokerHost = kafkaConfig.KAFKA_HOST;

  var consumerOpts = {
    kafkaHost: brokerHost,
    groupId: "mygroupid",
    protocol: ["roundrobin"],
  };

  var consumer = new kafka.ConsumerGroup(consumerOpts, topic);

  consumer.on("message", async (message) => {
    data = message.value.toString();
    console.log(JSON.stringify(data));
  });
  consumer.on("error", function (err) {
    console.log("error", err);
  });
};

console.log("node kafka consumer running!");
consumerController();
