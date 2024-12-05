# Use the official .NET SDK image to build and publish the app
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /app

# Copy the .csproj file and restore dependencies
COPY ./src/dotnet-hello-world.csproj ./src/
RUN dotnet restore ./src/dotnet-hello-world.csproj

# Copy the remaining files and build the app
COPY . ./
RUN dotnet publish ./src/dotnet-hello-world.csproj -c Release -o out

# Create a runtime image
FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /app
COPY --from=build /app/out .

# Expose the port and run the app
EXPOSE 80
ENTRYPOINT ["dotnet", "dotnet-hello-world.dll"]
