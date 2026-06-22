FROM eclipse-temurin:21-jdk-alpine AS build
WORKDIR /app
COPY .mvn/ .mvn/
COPY mvnw pom.xml ./
RUN chmod +x mvnw
RUN ./mvnw dependency:go-offline
COPY src ./src
RUN ./mvnw clean package -DskipTests

# Nayi line: .jar file ko move/rename kar do
RUN mv target/*.jar app.jar

# Run stage
FROM eclipse-temurin:21-jdk-alpine
WORKDIR /app
# Sirf jar file ko copy karo, baaki source code ko chhodo
COPY --from=build /app/app.jar .
EXPOSE 8080
CMD ["java", "-jar", "app.jar"]
