FROM node:lts-iron as builder


# Create app directory
WORKDIR /usr/src/app

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY package.json ./
COPY yarn.lock ./
# RUN npm install
# If you are building your code for production
RUN yarn

# Bundle app source
COPY . .

CMD [ "npm", "run", "prod"  ]
