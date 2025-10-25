# ===== Build stage =====
FROM maven:3.9.7-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
RUN mvn -q -e -DskipTests dependency:go-offline
COPY src ./src
RUN mvn -q -e -DskipTests package

# ===== Runtime stage (multi-arch) =====
FROM eclipse-temurin:17-jre-jammy
WORKDIR /app

# Seguridad: usuario no root
RUN useradd -m app
USER app

ENV PORT=8000
ENV SPRING_PROFILES_ACTIVE=default

COPY --from=build /app/target/*.jar /app/app.jar
EXPOSE 8000

ENTRYPOINT ["java","-Dserver.port=${PORT}","-jar","/app/app.jar"]
