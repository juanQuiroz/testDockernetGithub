#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["DockerAuto.csproj", "DockerAuto/"]
RUN dotnet restore "DockerAuto/DockerAuto.csproj"
COPY . .
WORKDIR "/src/DockerAuto"
RUN dotnet build "DockerAuto.csproj" -c Release -o src/app/build

FROM build AS publish
RUN dotnet publish "DockerAuto.csproj" -c Release -o src/app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "DockerAuto.dll"]