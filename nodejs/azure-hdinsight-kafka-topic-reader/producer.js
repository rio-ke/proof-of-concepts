const { Kafka } = require("kafkajs");

async function run() {
  const kafka = new Kafka({ brokers: ["localhost:9092"] });

  const producer = kafka.producer();
  await producer.connect();
  let data = {
    Records: [
      {
        eventVersion: "2.1",
        eventSource: "aws:s3",
        awsRegion: "ap-southeast-1",
        eventTime: "2022-07-31T06:54:20.293Z",
        eventName: "ObjectCreated:Put",
        userIdentity: { principalId: "A3H9EVE2DDNAB9" },
        requestParameters: { sourceIPAddress: "49.204.113.169" },
        responseElements: {
          "x-amz-request-id": "19M5DNJ0952B8HJY",
          "x-amz-id-2":
            "b93R+PNOtzjViMz5mxq8W1ejFIKcjjRmlBDpvRfHhzxE6NJJm1jOV36cJUkI7fcLNARrPiSsofkQ7xHIR2Q4hSGb6JO9IcBH",
        },
        s3: {
          s3SchemaVersion: "1.0",
          configurationId: "pre-sign-url",
          bucket: {
            name: "pre-signed-url-local",
            ownerIdentity: { principalId: "A3H9EVE2DDNAB9" },
            arn: "arn:aws:s3:::pre-signed-url-local",
          },
          object: {
            key: "job-one.py",
            size: 205,
            eTag: "b5cfdce177d589dd39243adf1cec46e7",
            sequencer: "0062E6271C43DE0B18",
          },
        },
      },
    ],
  };
  await producer.send({
    topic: "MX_Response_Builder_Ingress",
    messages: [{ value: JSON.stringify(data) }],
  });
}

run().then(
  () => console.log("Done"),
  (err) => console.log(err)
);
