FROM node:carbon

WORKDIR /app

ENV PATH /app/node_modules/.bin:$PATH

COPY package*.json ./

RUN npm i

COPY . .

EXPOSE 3000
CMD [ "npm", "start" ]