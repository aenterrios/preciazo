FROM cgr.dev/chainguard/wolfi-base AS base
WORKDIR /usr/src/app

FROM base as build
RUN apk add --no-cache nodejs npm
RUN npm install --global pnpm
COPY . .
RUN cd sitio && \
    pnpm install && \
    pnpm build

FROM base
ENV NODE_ENV=production
RUN apk add --no-cache nodejs npm jq sqlite

# Sitio
COPY --from=build /usr/src/app/sitio/package.json package.real.json
RUN sh -c 'echo {\"name\":\"sitio\",\"type\":\"module\",\"dependencies\":$(jq .dependencies < package.real.json)} > package.json' && npm install
COPY --from=build /usr/src/app/db-datos node_modules/db-datos
COPY --from=build /usr/src/app/sitio/build .
COPY --from=build /usr/src/app/db-datos/drizzle .

ENV DB_PATH=/db/db.db
EXPOSE 3000

CMD ["node", "."]