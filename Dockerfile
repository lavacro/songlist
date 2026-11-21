# build stage
ARG APP_VERSION="1.23.5"

FROM docker.io/gradle:9-jdk27 AS builder
ARG APP_VERSION
WORKDIR /build
COPY . .
RUN ./gradlew build -x test

# runtime stage
FROM registry:5000/awscorretto:27-alpine
ARG APP_VERSION="1.23.5"
COPY --from=builder /build/build/libs/songlist-${APP_VERSION}.jar /app/songlist.jar
WORKDIR /app
USER nobody
ENTRYPOINT ["/bin/sh", "-c", "java -jar songlist.jar"]
