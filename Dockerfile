ARG NODE=node:22-alpine

# Stage 1: Build
FROM ${NODE} AS builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
ENV NODE_ENV=production
RUN npm run build


# Stage 2: Runner
FROM ${NODE}
WORKDIR /app
COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/.next/static ./.next/static
COPY --from=builder /app/public ./public
ENV PORT=3000
ENV NEXT_TELEMETRY_DISABLED=1
EXPOSE 3000
CMD [ "node", "server.js" ]