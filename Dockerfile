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


# ------------------- RUNTIME STAGE -------------------
FROM nginx:alpine AS runtime
RUN apk add --no-cache bash

COPY ./nginx/nginx.conf /etc/nginx/nginx.conf
COPY --from=build /app/dist /usr/share/nginx/html
COPY default.config.json /app/default/config.json 


COPY entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/entrypoint.sh
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

CMD []

EXPOSE 8080

LABEL org.opencontainers.image.source=https://github.com/caslus/kiss