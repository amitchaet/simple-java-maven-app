# ─────────────────────────────────────
# 🏗️ Stage 1: Build with Maven
# ─────────────────────────────────────
FROM maven:3.9.6-eclipse-temurin-17 AS build

WORKDIR /app

# Copy pom.xml and download dependencies early for better caching
COPY pom.xml .
RUN mvn dependency:go-offline

# Now copy the rest of the source
COPY src ./src

# Build the application
RUN mvn clean package -DskipTests

# ─────────────────────────────────────
# 🚀 Stage 2: Run with JDK
# ─────────────────────────────────────
FROM openjdk:17-jdk-slim

WORKDIR /app

# Copy only the built JAR from the previous stage
COPY --from=build /app/target/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "/app/app.jar"]
