# Multi-stage build: Builds WAR inside container
# This ensures consistency across different build machines and avoids corruption issues

FROM maven:3.8-openjdk-11 AS builder
WORKDIR /build

# Copy source code
COPY pom.xml .
COPY src ./src
COPY webapp ./webapp

# Build WAR with proper output buffering
RUN mvn clean package -DskipTests -q && \
    unzip -t target/ctoon-1.0-SNAPSHOT.war > /dev/null && \
    echo "WAR file verified: $(ls -lh target/ctoon-1.0-SNAPSHOT.war | awk '{print $5}')"

# Final stage: Runtime environment
FROM tomcat:9.0-jdk17-temurin
WORKDIR /usr/local/tomcat

# Remove default ROOT application
RUN rm -rf webapps/ROOT webapps/ROOT.war webapps/docs webapps/examples

# Copy built WAR from builder stage
COPY --from=builder /build/target/ctoon-1.0-SNAPSHOT.war webapps/ROOT.war

# Verify WAR file exists and is not empty
RUN test -s webapps/ROOT.war || (echo "ERROR: WAR file missing or corrupted"; exit 1) && \
    echo "WAR file size: $(du -h webapps/ROOT.war | cut -f1)"

# Configure Java memory and Tomcat options
ENV JAVA_OPTS="-Xmx512m -Xms256m"
ENV CATALINA_OPTS="-Xmx512m -Xms256m -Djava.awt.headless=true"

# Expose Tomcat port
EXPOSE 8080

# Health check with retry logic
HEALTHCHECK --interval=30s --timeout=10s --start-period=60s --retries=5 \
    CMD curl -sf http://localhost:8080/health > /dev/null || exit 1

# Start Tomcat in foreground mode (important for Docker)
CMD ["catalina.sh", "run"]