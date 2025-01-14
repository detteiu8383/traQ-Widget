# alpineにするとnode-gypで死ぬ
FROM node:14 as build
WORKDIR /app

COPY package*.json ./
RUN --mount=type=cache,id=npm,target=/root/.npm \
  npm ci

# build/Caddyfile以外をコピーする
COPY ./src/ ./src/
COPY ./index.html .
COPY ./tsconfig.json .
COPY ./vite.config.ts .
RUN npm run build


FROM caddy:2.4.0-alpine
EXPOSE 80
COPY build/Caddyfile /etc/caddy/Caddyfile
COPY --from=build /app/dist /usr/share/caddy
