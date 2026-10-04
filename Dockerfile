FROM node:24-slim

ENV NEXT_TELEMETRY_DISABLED=1

WORKDIR /app

# Install dependencies first so this layer is cached when only code changes
COPY package.json package-lock.json* ./
RUN if [ -f package-lock.json ]; then npm ci; else npm install; fi

# Copy the rest of the frontend
COPY . .

# Where the Next.js server forwards /api/* requests (read in next.config.js).
# "backend" is the backend container's name on the shared Docker network.
# Next fixes this at build time, so a different URL needs a rebuild:
#   docker build --build-arg BACKEND_URL=http://some-host:8000 -t frontend .
ARG BACKEND_URL=http://backend:8000
ENV BACKEND_URL=${BACKEND_URL}

RUN npm run build

ENV NODE_ENV=production \
    PORT=3000

EXPOSE 3000

# Run next directly (not via npm) so `docker stop` shuts it down promptly
CMD ["./node_modules/.bin/next", "start", "--hostname", "0.0.0.0"]