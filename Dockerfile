#Depending on the operating system of the host machines(s) that will build or run the containers, the image specified in the FROM statement may need to be changed.
#For more information, please see https://aka.ms/containercompat

FROM mcr.microsoft.com/dotnet/core/aspnet:2.1-nanoserver-1809 AS base
WORKDIR /app
EXPOSE 80

FROM mcr.microsoft.com/dotnet/core/sdk:2.1-nanoserver-1809 AS build
WORKDIR /src
COPY DockerTest_PedroViana/DockerTest_PedroViana.csproj DockerTest_PedroViana/
RUN dotnet restore DockerTest_PedroViana/DockerTest_PedroViana.csproj
COPY . .
WORKDIR "/src/DockerTest_PedroViana"
RUN dotnet build "DockerTest_PedroViana.csproj" -c Release -o /app

FROM build AS publish
RUN dotnet publish "DockerTest_PedroViana.csproj" -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "DockerTest_PedroViana.dll"]