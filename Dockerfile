# ==== Build stage ====
FROM maven:3.9.7-eclipse-temurin-17 AS build
WORKDIR /app
COPY pom.xml .
RUN mvn -q -e -DskipTests dependency:go-offline
COPY src ./src
RUN mvn -q -e -DskipTests package

# ==== Runtime stage ====
FROM eclipse-temurin:17-jre-alpine
WORKDIR /app

# Seguridad: usuario no root
RUN addgroup -S app && adduser -S app -G app
USER app

# Variables inyectables
ENV PORT=8000
ENV SPRING_PROFILES_ACTIVE=default

# Copiar jar
COPY --from=build /app/target/*.jar app.jar

EXPOSE 8000
# Healthcheck simple contra un endpoint público de la app (lista usuarios)
HEALTHCHECK --interval=30s --timeout=3s --retries=3 CMD wget -qO- http://127.0.0.1:${PORT}/api/users || exit 1

ENTRYPOINT ["java","-Dserver.port=${PORT}","-jar","/app/app.jar"]
