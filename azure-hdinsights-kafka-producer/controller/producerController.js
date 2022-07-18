const kafka = require("kafka-node");
const kafkaConfig = require("../configuration/kafkaConfig");

const producerController = (req, res) => {
  var topic = kafkaConfig.KAFKA_TOPIC;
  var brokerHost = kafkaConfig.KAFKA_HOST;
  var client = new kafka.KafkaClient({ kafkaHost: brokerHost });
  var producer = new kafka.Producer(client, { requireAcks: 1 });

  let data = req.body;
  console.log(data);
  let payloads = [
    {
      topic: topic,
      messages: JSON.stringify(data),
    },
  ];

  producer.send(payloads, (err, data) => {
    if (err) {
      console.log("broker update success");
      res.status(500).send({
        Posted: "broker update failed",
        status: err,
      });
    } else {
      console.log("broker update success");
      res.status(202).send({
        Posted: "broker update success",
        status: data,
      });
    }
  });
};

module.exports = producerController;
