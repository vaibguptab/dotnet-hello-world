# Use the official .NET Core 2.0 SDK image to build and publish the app
FROM mcr.microsoft.com/dotnet/core/sdk:2.0 AS build
WORKDIR /src

# Copy the .csproj file from the hello-world-api folder and restore dependencies
COPY ./hello-world-api/hello-world-api.csproj ./
RUN dotnet restore hello-world-api.csproj

# Copy the remaining files from the hello-world-api folder and build the app
COPY ./hello-world-api/. ./
RUN dotnet publish hello-world-api.csproj -c Release -o /app/out

# Create a runtime image using the .NET Core 2.0 runtime
FROM mcr.microsoft.com/dotnet/core/aspnet:2.0 AS runtime
WORKDIR /app
COPY --from=build /app/out ./

# Expose the port the app runs on
EXPOSE 80

# Run the application
ENTRYPOINT ["dotnet", "hello-world-api.dll"]
