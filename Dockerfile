FROM registry.access.redhat.com/ubi8/nodejs-10

USER root

RUN mkdir /app
WORKDIR /app

COPY package.json /app
RUN npm install --only=prod
COPY server /app/server
COPY public /app/public

ENV NODE_ENV production
ENV PORT 3000

EXPOSE 3000

CMD ["node", "server/server.js"]
