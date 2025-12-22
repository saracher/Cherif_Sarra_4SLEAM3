FROM openjdk:17.0.1-jdk-slim
WORKDIR /app
COPY target/*.jar .
EXPOSE 8089
ENTRYPOINT ["java","-jar","student-management-0.0.1-SNAPSHOT.jar"]
