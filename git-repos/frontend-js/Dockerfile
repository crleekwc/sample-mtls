# First stage builds the application
#FROM registry.redhat.io/ubi9/nodejs-14 as builder
FROM registry.access.redhat.com/ubi8/nodejs-18 as builder

# Add application sources
COPY package.json $HOME
# Install the dependencies
RUN npm install 
COPY server.js $HOME


# Second stage copies the application to the minimal image
FROM registry.access.redhat.com/ubi8/nodejs-18-minimal

# Copy the application source and build artifacts from the builder image to this one
COPY --from=builder $HOME $HOME

# Run script uses standard ways to run the application
EXPOSE 8080
USER 1001
CMD [ "node", "server.js" ]

# If you use mac m1 => "add --platform linux/amd64"

