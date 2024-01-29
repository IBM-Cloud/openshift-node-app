FROM registry.access.redhat.com/ubi8/nodejs-20

USER 0
RUN fix-permissions ./
USER 1001

RUN mkdir ./app
WORKDIR $HOME/app
COPY package.json .
RUN npm install --omit=dev
COPY server ./server
COPY public ./public

ENV NODE_ENV production
ENV PORT 3000

EXPOSE 3000

CMD ["node", "server/server.js"]
