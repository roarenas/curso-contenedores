FROM node:24

WORKDIR /usr/app

COPY package*.json .
RUN npm ci

COPY nest-cli.json tsconfig*.json ./
COPY src ./src

RUN npm run build

EXPOSE 3000

CMD ["node", "dist/main.js"]