# ------------------- BUILD STAGE -------------------
FROM node:lts-alpine AS build
ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"
RUN corepack enable
WORKDIR /app

COPY package*.json ./
RUN pnpm install
COPY . .
RUN pnpm run build

FROM golang:1.21-alpine AS go-build
WORKDIR /go-app
COPY ./scripts/health.go .
RUN CGO_ENABLED=0 GOOS=linux go build -o health-check-proxy health.go

# ------------------- RUNTIME STAGE -------------------
FROM nginx:alpine AS runtime
RUN apk add --no-cache bash curl jq

COPY ./nginx/nginx.conf /etc/nginx/nginx.conf
COPY --from=build /app/dist /usr/share/nginx/html
COPY default.config.json /app/default/config.json 

COPY --from=go-build /go-app/health-check-proxy /usr/local/bin/health-check-proxy


COPY scripts/ /usr/local/bin/scripts/
RUN chmod +x /usr/local/bin/scripts/*.sh
ENTRYPOINT ["/usr/local/bin/scripts/entrypoint.sh"]

CMD []

EXPOSE 8080

LABEL org.opencontainers.image.source=https://github.com/caslus/kiss