const express = require("express");
const { Kafka } = require("kafkajs");
const topicsData = require("./topicsData");
const topicReader = new topicsData();

// let KAFKA_HOST = ["localhost:9092"];
let KAFKA_HOST = ["10.42.60.7:9092", "10.42.60.5:9092", "10.42.60.6:9092"];

const app = express();
app.use(express.json());

const kafkaTopic = async (topic) => {
  const kafka = new Kafka({ brokers: KAFKA_HOST });
  const consumer = kafka.consumer({ groupId: topic + Date.now() });
  await consumer.connect();
  await consumer.subscribe({ topic: topic, fromBeginning: true });
  await consumer.run({
    eachMessage: async (data) => {
      var topicData = data.message.value.toString();
      topicReader.setMessages(data.topic, data.message.offset, topicData);
    },
  });
};

app.get("/kafka", async (req, res) => {
  res.json(topicReader);
});

app.get("/kafka/topics/", (req, res) => {
  let topic = req.query.topic;
  if (topic === "CBPR_Validator_Ingress") res.json(topicReader[topic]);
  else if (topic === "Error") res.json(topicReader[topic]);
  else if (topic === "MX2MT_Transformer_Ingress") res.json(topicReader[topic]);
  else if (topic === "MT_Builder_Ingress") res.json(topicReader[topic]);
  else if (topic === "MX_Response_Builder_Ingress")
    res.json(topicReader[topic]);
  else if (topic === "MT2MX_Transformer_Ingress") res.json(topicReader[topic]);
  else if (topic === "MX_Validator_Ingress") res.json(topicReader[topic]);
  else if (topic === "MT_Validator_Ingress") res.json(topicReader[topic]);
  else if (topic === "MT_Response_Builder_Ingress")
    res.json(topicReader[topic]);
  else if (topic === "MT_Ingestor_Ingress") res.json(topicReader[topic]);
  else if (topic === "ISOConvertor_Response") res.json(topicReader[topic]);
  else if (topic === "MX_Builder_Ingress") res.json(topicReader[topic]);
  else if (topic === "ISOConvertor_MT2MX_Response")
    res.json(topicReader[topic]);
  else if (topic === "balance") res.send(topicReader[topic]);
  else res.json({ status: "topic not found", statusCode: 404 });
});

app.listen(9000, () => {
  kafkaTopic("CBPR_Validator_Ingress");
  kafkaTopic("Error");
  kafkaTopic("MX2MT_Transformer_Ingress");
  kafkaTopic("MT_Builder_Ingress");
  kafkaTopic("MX_Response_Builder_Ingress");
  kafkaTopic("MT2MX_Transformer_Ingress");
  kafkaTopic("MX_Validator_Ingress");
  kafkaTopic("MT_Validator_Ingress");
  kafkaTopic("MT_Response_Builder_Ingress");
  kafkaTopic("MT_Ingestor_Ingress");
  kafkaTopic("ISOConvertor_Response");
  kafkaTopic("MX_Builder_Ingress");
  kafkaTopic("ISOConvertor_MT2MX_Response");
});
