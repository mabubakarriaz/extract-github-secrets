#See https://aka.ms/customizecontainer to learn how to customize your debug container and how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
USER app
WORKDIR /app
EXPOSE 8080
EXPOSE 8081

# Add labels here
LABEL org.opencontainers.image.source=https://github.com/mabubakarriaz/extract-github-secrets
LABEL org.opencontainers.image.description="Save GitHub repository secrets in plain text to azure cosmos table using C# REST API."
LABEL org.opencontainers.image.licenses=Apache

FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
ARG BUILD_CONFIGURATION=Release
WORKDIR /src
COPY ["extract-github-secrets.csproj", "."]
RUN dotnet restore "./extract-github-secrets.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "./extract-github-secrets.csproj" -c $BUILD_CONFIGURATION -o /app/build

FROM build AS publish
ARG BUILD_CONFIGURATION=Release
RUN dotnet publish "./extract-github-secrets.csproj" -c $BUILD_CONFIGURATION -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "extract-github-secrets.dll"]