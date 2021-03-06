FROM node:12-alpine as builder
ENV NODE_ENV build
USER node
WORKDIR /home/node
COPY . /home/node
RUN npm install \
    && npm run test \
    && npm run build
# ---
FROM node:12-alpine
ENV NODE_ENV production
USER node
WORKDIR /home/node
COPY --from=builder /home/node/dist/ /home/node/dist
COPY --from=builder /home/node/package*.json /home/node/
RUN npm ci
EXPOSE 8000
CMD ["node", "dist/main.js"]
