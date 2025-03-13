FROM node:16

# Set working directory
WORKDIR /home/app

# Install dependencies
RUN apt-get update && apt-get install -y htop

# Copy application code
COPY . .

# Install Node.js dependencies
RUN npm install

# Expose the application port
EXPOSE 8080

# Start the application
CMD ["npm", "start"]
