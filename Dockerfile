# Build stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

COPY ["BarcodeApi.csproj", "."]
RUN dotnet restore "BarcodeApi.csproj"

COPY . .
RUN dotnet build "BarcodeApi.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "BarcodeApi.csproj" -c Release -o /app/publish

# Runtime stage
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app

COPY --from=publish /app/publish .

# Install libgdiplus for System.Drawing.Common
RUN apt-get update && apt-get install -y libgdiplus && rm -rf /var/lib/apt/lists/*

EXPOSE 80
EXPOSE 443

ENTRYPOINT ["dotnet", "BarcodeApi.dll"]
