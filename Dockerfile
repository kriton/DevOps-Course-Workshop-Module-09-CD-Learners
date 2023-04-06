
FROM mcr.microsoft.com/dotnet/sdk:6.0 as build-stage

RUN curl -fsSL https://deb.nodesource.com/setup_19.x | bash - &&\
    apt-get install -y nodejs

#Copy Code
WORKDIR /app

COPY . /app/

#Build
RUN dotnet build

WORKDIR /app/DotnetTemplate.Web
RUN npm install && npm run build

#Test
WORKDIR /app
RUN dotnet test

WORKDIR /app/DotnetTemplate.Web
RUN npm t

WORKDIR /app/DotnetTemplate.Web
RUN cd /app/DotnetTemplate.Web && npm run lint


FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /app
COPY --from=build /app .
CMD ["dotnet","run"]
