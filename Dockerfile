# Use the official .NET SDK image to build and publish the app
FROM mcr.microsoft.com/dotnet/core/sdk:2.0 AS build
WORKDIR /app

COPY ./hello-world-api/hello-world-api.csproj ./hello-world-api/
RUN dotnet restore ./hello-world-api/hello-world-api.csproj

COPY ./hello-world-api/. ./hello-world-api/
RUN dotnet publish ./hello-world-api/hello-world-api.csproj -c Release -o out

FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /app
COPY --from=build /app/out .

EXPOSE 80
ENTRYPOINT ["dotnet", "hello-world-api.dll"]
