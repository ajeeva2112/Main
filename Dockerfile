# Development stage
FROM node:22-alpine AS development

WORKDIR /app

COPY package.json ./
COPY npm-shrinkwrap.json ./
COPY .npmrc ./

# Install dependencies
RUN npm ci --engine-strict=false

# Copy source files
COPY .*.js ./
COPY *config.?js ./
COPY vite.config.ts ./
COPY index.html ./
COPY public ./public
COPY src ./src

CMD ["npm", "start"]

# Build stage
FROM development AS builder
RUN npm run build

# Production stage
FROM nginx:1.21-alpine AS production
COPY --from=builder /app/build /usr/share/nginx/html
