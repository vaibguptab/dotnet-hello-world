# Use .NET 6 SDK for building
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src

# Copy and restore dependencies
COPY ./hello-world-api/hello-world-api.csproj ./
RUN dotnet restore hello-world-api.csproj

# Copy source files and build the application
COPY ./hello-world-api/. ./
RUN dotnet publish hello-world-api.csproj -c Release -o /app/out

# Use .NET 6 runtime
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS runtime
WORKDIR /app
COPY --from=build /app/out ./

# Expose port and run the app
EXPOSE 80
ENTRYPOINT ["dotnet", "hello-world-api.dll"]
