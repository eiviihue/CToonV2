# Use the official Tomcat base image
FROM tomcat:9.0

# Set the working directory inside the container
WORKDIR /usr/local/tomcat

# Remove the default ROOT application
RUN rm -rf webapps/ROOT

# Copy the WAR file to the Tomcat webapps directory
COPY target/ctoon-1.0-SNAPSHOT.war webapps/ROOT.war

# Expose the default Tomcat port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]