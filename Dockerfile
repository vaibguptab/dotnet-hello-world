# Use the official .NET SDK image to build and publish the app
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /app

# Copy the .csproj file from the hello-world-api folder and restore dependencies
COPY ./hello-world-api/dotnet-hello-world.csproj ./hello-world-api/
RUN dotnet restore ./hello-world-api/dotnet-hello-world.csproj

# Copy the remaining files from the hello-world-api folder and build the app
COPY ./hello-world-api/. ./hello-world-api/
RUN dotnet publish ./hello-world-api/dotnet-hello-world.csproj -c Release -o out

# Create a runtime image
FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /app
COPY --from=build /app/out .

# Expose the port and run the app
EXPOSE 80
ENTRYPOINT ["dotnet", "hello-world-api.dll"]
