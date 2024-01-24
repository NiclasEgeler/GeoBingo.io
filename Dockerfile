# Stage 1: Frontend build
FROM node:lts-iron as frontend-builder

# Create app directory
WORKDIR /usr/src/app

COPY ./Frontend/package.json ./
COPY ./Frontend/yarn.lock ./

RUN yarn

# Bundle app source
COPY ./Frontend .

ARG VITE_DOMAIN
ARG VITE_GMAPSAPI
ARG VITE_SUPABASE_KEY
ARG VITE_SUPABASE_URL

ENV VITE_DOMAIN=$VITE_DOMAIN
ENV VITE_GMAPSAPI=$VITE_GMAPSAPI
ENV VITE_SUPABASE_KEY=$VITE_SUPABASE_KEY
ENV VITE_SUPABASE_URL=$VITE_SUPABASE_URL

RUN npm run build

# Stage 2: Backend build
FROM node:lts-iron as backend-builder

# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
COPY ./Backend/package.json ./
COPY ./Backend/yarn.lock ./
RUN yarn

# Bundle app source
COPY ./Backend .

# Stage 3: Combine Frontend and Backend into a single image
FROM nginx

# Copy built frontend from the frontend-builder stage
COPY --from=frontend-builder /usr/src/app/build /usr/share/nginx/html

# Copy backend from the backend-builder stage
COPY --from=backend-builder /usr/src/app /usr/src/app

# Set working directory for the backend
WORKDIR /usr/src/app

# Start the backend
CMD [ "npm", "run", "prod" ]