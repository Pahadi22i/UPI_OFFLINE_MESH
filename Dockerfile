# Use an official OpenJDK 21 runtime as a parent image
FROM eclipse-temurin:21-jdk-alpine

# Set the working directory
WORKDIR /app

# Copy the mvnw and pom.xml first to cache dependencies
COPY .mvn/ .mvn/
COPY mvnw pom.xml ./
RUN chmod +x mvnw

# Download dependencies
RUN ./mvnw dependency:go-offline

# Copy the rest of the source code and build
COPY src ./src
RUN ./mvnw clean package -DskipTests

# Expose the port (Render will use $PORT)
EXPOSE 8080

# Run the jar file
CMD ["java", "-jar", "target/*.jar"]
