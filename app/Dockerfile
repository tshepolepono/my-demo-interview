FROM node:alpine
RUN addgroup -S pipeline && adduser -S docker-pipeline -G pipeline
USER docker-pipeline
WORKDIR /usr/src/app
COPY . .
RUN npm ci --only-production && npm run build
EXPOSE 80
CMD ["npm", "start"]
