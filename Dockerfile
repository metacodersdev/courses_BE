# flyctl init
# flyctl launch (load fly.toml or create new)
# flyctl destroy [appname]
# flyctl logs [appname]
FROM node:18 as build-image
RUN apt-get update && apt-get install -y openssl
WORKDIR /usr/src/app
COPY package*.json ./
COPY tsconfig.json ./
COPY ./prisma ./prisma
COPY ./src ./src
RUN npm i
#RUN npx prisma db push
RUN npx tsc

FROM node:18
WORKDIR /usr/src/app
COPY package*.json ./
COPY --from=build-image ./usr/src/app/dist ./dist
RUN npm i --production
COPY . .
EXPOSE 8080
CMD [ "node", "dist/index.js" ]