# Single stage: uses pre-built WAR from local build
FROM tomcat:9.0-jdk17-temurin
WORKDIR /usr/local/tomcat

# Remove default ROOT app
RUN rm -rf webapps/ROOT

# Copy the pre-built WAR file into Tomcat's webapps as ROOT.war
# Expects WAR to be at ./target/ctoon-1.0-SNAPSHOT.war (built locally via Maven)
COPY target/ctoon-1.0-SNAPSHOT.war webapps/ROOT.war

# Expose default Tomcat port
EXPOSE 8080

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=40s --retries=3 \
    CMD curl -f http://localhost:8080/ || exit 1

# Start Tomcat
CMD ["catalina.sh", "run"]