# Multi-stage build: build WAR with Maven (Java 17), then copy into Tomcat
FROM maven:3.9.5-eclipse-temurin-17 AS builder
WORKDIR /workspace

# Copy only what we need for a Maven build to leverage layer caching
COPY pom.xml .
# Copy source, webapp, and static assets so the in-container Maven build includes JSPs and resources
COPY src ./src
COPY webapp ./webapp
# Build the WAR (skip tests to speed up builds in CI)
RUN mvn -B -DskipTests clean package

FROM tomcat:9.0-jdk17-temurin
WORKDIR /usr/local/tomcat

# Remove default ROOT app
RUN rm -rf webapps/ROOT

# Copy the built WAR from the builder stage into Tomcat's webapps as ROOT.war
COPY --from=builder /workspace/target/*.war webapps/ROOT.war

# Expose default Tomcat port
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]