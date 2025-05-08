FROM node:alpine AS builder

RUN apk add --update curl && \
rm -rf /var/cache/apk/*

WORKDIR /usr/app

COPY ./package.json ./

RUN npm install

COPY . .

FROM node:alpine 

WORKDIR /usr/app

COPY --from=builder /usr/app /usr/app

RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

EXPOSE 3000

HEALTHCHECK --interval=10s --timeout=1s \
  CMD curl -f http://localhost:8080/ || exit 1

CMD ["node", "index.js"]


