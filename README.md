# Docker-Cantaloupe

Provides a basic docker container for 🍈 with all the image tools installed. Based on the [Ubuntu 16.04 image](https://hub.docker.com/_/ubuntu/).

## Environment Variables

### User

Inside the container Cantaloupe is run as a user named *Cantaloupe*. The UID and GID of this user can be controlled by setting the following environment variables:

* `CANTALOUPE_UID`
* `CANTALOUPE_GID`

Both of these default to 999. 

### Java

The arguements passed to Java when starting Cantaloupe can be controlled with:

* `JAVA_OPTS`

Default: `-Xmx500m`

### Cantaloupe.properties

The path that cantaloupe looks for *cantaloupe.properties* is configured by: 

* `PROPERTIES_FILE`. 

Default: `/cantaloupe/cantaloupe.properties`

You can change this if you want to mount your own cantaloupe.properties inside of the container. By default almost all of the cantaloupe.properties configuration is customized using environment variables. You can find the details of the environment variables you can set [here](cantaloupe.properties).  

`docker build -t cantaloupe .`

## Paths

Most of the paths are customizable using environment variables, but by default they are all located in `/cantaloupe`:
* Cache: `/cantaloupe/cache`
* Logs: `/cantaloupe/logs`
* Image Source: `/cantaloupe/images`

## Docker Compose Example

```yaml
version: '3.2'
services:
  contaloupe:
    container_name: cantaloupe
    image: lyrasis/cantaloupe:latest
    ports:
        - "8182:8182"
    environment:
        ENDPOINT_ADMIN_ENABLED: "false"
        PRINT_STACK_TRACE_ON_ERROR_PAGES: "false"
        ENDPOINT_IIIF_1_ENABLED: "false"
        ENDPOINT_IIIF_2_ENABLED: "true"
        ENDPOINT_API_ENABLED: "false"
        CACHE_SERVER_TTL_SECONDS: "1296000"
        CACHE_SERVER_WORKER_INTERVAL: "3600"
        HTTPRESOLVER_REQUEST_TIMEOUT: "60"
        RESOLVER_STATIC: "HttpResolver"
        HTTPRESOLVER_BASICLOOKUPSTRATEGY_URL_PREFIX: ""
        HTTPRESOLVER_BASICLOOKUPSTRATEGY_URL_SUFFIX: ""
        CACHE_SERVER_SOURCE_ENABLED: "true"
        CACHE_SERVER_DERIVATIVE_ENABLED: "true"
        CACHE_SERVER_DERIVATIVE: "FilesystemCache"
        JAVA_OPTS: "-Xmx2g"
        PROCESSOR_JP2: "OpenJpegProcessor"
    restart: always
```
