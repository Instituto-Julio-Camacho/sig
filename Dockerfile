FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /app

# copy csproj and restore as distinct layers
COPY SIG/SIG.Blazor/*.csproj ./SIG.Blazor/
WORKDIR /app/SIG.Blazor
RUN dotnet restore

# copy and publish app and libraries
WORKDIR /app/
COPY SIG/SIG.Blazor/. ./SIG.Blazor/
WORKDIR /app/SIG.Blazor
RUN dotnet publish -c Release -o out

FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS runtime
WORKDIR /app
COPY --from=build /app/SIG.Blazor/out ./
ENTRYPOINT ["dotnet", "SIG.Blazor.dll"]
