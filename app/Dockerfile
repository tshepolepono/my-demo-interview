FROM node:alpine
RUN addgroup -S pipeline && adduser -S k8s-pipeline -G pipeline
USER k8s-pipeline
WORKDIR /usr/src/app
COPY . .
RUN npm ci --only-production && npm run build
EXPOSE 80
CMD ["npm", "start"]
