# ========== Stage 1: Build the application ==========
FROM eclipse-temurin:17-jdk-jammy AS builder

WORKDIR /app

# Copy Maven wrapper and project files
COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .

# Pre-download dependencies (faster builds)
RUN ./mvnw dependency:go-offline

# Copy the source and build the application
COPY src src
RUN ./mvnw -DskipTests package


# ========== Stage 2: Run the application ==========
FROM eclipse-temurin:17-jre-jammy

WORKDIR /app

# Expose application port
EXPOSE 9966

# Copy JAR from builder stage
COPY --from=builder /app/target/*.jar app.jar

# Start the Spring Boot app
ENTRYPOINT ["java", "-jar", "app.jar"]
