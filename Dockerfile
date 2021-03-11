#
# Build stage
#
FROM maven:3.6.3-jdk-11-slim AS build
RUN mkdir -p /usr/src/app/src
COPY pom.xml /usr/src/app
RUN mvn -f /usr/src/app/pom.xml dependency:go-offline
COPY src /usr/src/app/src
RUN mvn -f /usr/src/app/pom.xml clean package
#
# Package stage
#
FROM gcr.io/distroless/java
COPY --from=build /usr/src/app/target/demo-0.0.1-SNAPSHOT.jar /usr/app/demo.jar
EXPOSE 5000
ENTRYPOINT ["java","-jar","/usr/app/demo.jar"]