FROM node:alpine
WORKDIR /app
COPY package.json .
RUN npm install
COPY . .
CMD ["node", "main.js"]

# docker push jjino/azure-hdinsight-kafka-consumer:final