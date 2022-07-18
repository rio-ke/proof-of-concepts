kafkaConfig = {
  KAFKA_HOST: process.env.KAFKA_HOST || "localhost:9092",
  KAFKA_TOPIC: process.env.KAFKA_TOPIC || "balance",
};

module.exports = kafkaConfig;
