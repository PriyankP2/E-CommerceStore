FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install --production
COPY . .
EXPOSE 3003
HEALTHCHECK --interval=30s --timeout=10s --start-period=20s \
  CMD wget -qO- http://localhost:3003/health || exit 1
CMD ["node", "server.js"]
