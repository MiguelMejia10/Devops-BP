# ===== Build =====
FROM maven:3.9.7-eclipse-temurin-17 AS build
WORKDIR /src
COPY pom.xml .
RUN mvn -q -DskipTests dependency:go-offline
COPY src ./src
RUN mvn -q -DskipTests package

# ===== Runtime (multi-arch) =====
FROM eclipse-temurin:17-jre-jammy

# 1) Prepara carpeta y permisos
WORKDIR /app
# crea el usuario con uid estable y DA permisos sobre /app
RUN useradd -m -u 10001 app && chown -R app:app /app

# 2) Variables
ENV PORT=8000
ENV SPRING_PROFILES_ACTIVE=default
# (opcional) fuerza H2 a escribir en subcarpeta /app/data
# ENV SPRING_DATASOURCE_URL=jdbc:h2:file:/app/data/test;DB_CLOSE_DELAY=-1;DB_CLOSE_ON_EXIT=FALSE
RUN mkdir -p /app/data && chown -R app:app /app/data

# 3) Copia artefacto y baja privilegios
COPY --from=build /src/target/*.jar /app/app.jar
USER app

EXPOSE 8000
ENTRYPOINT ["java","-Dserver.port=${PORT}","-jar","/app/app.jar"]