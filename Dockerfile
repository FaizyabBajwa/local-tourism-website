# ---------- STAGE 1: Build the website ----------
FROM node:18-alpine AS builder

# Set working directory inside the container
WORKDIR /app

# Copy package files first (for better caching)
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the project files
COPY . .

# Build the static website using Parcel
RUN npx parcel build src/index.html --public-url ./

# ---------- STAGE 2: Serve the website ----------
FROM nginx:alpine

# Copy built files from Stage 1 into Nginx's web folder
COPY --from=builder /app/dist /usr/share/nginx/html

# Expose port 80 (default web port)
EXPOSE 80

# Start Nginx server
CMD ["nginx", "-g", "daemon off;"]