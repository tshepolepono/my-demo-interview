FROM node:15

WORKDIR /usr/src/app

COPY . .
RUN npm install && npm run build

EXPOSE 80
CMD ["npm", "start"]



