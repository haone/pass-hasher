FROM mcr.microsoft.com/dotnet/core/aspnet:3.1-buster-slim AS build-env
WORKDIR /app
EXPOSE 5000

FROM mcr.microsoft.com/dotnet/core/sdk:3.1-buster AS build
WORKDIR /src
COPY ["password-hasher.csproj", ""]
RUN dotnet restore "./password-hasher.csproj"
COPY . .
WORKDIR "/src/"
RUN dotnet build "password-hasher.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "password-hasher.csproj" -c Release -o /app/publish

FROM build-env AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "password-hasher.dll"]
