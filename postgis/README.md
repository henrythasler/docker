# postgis container

## build

    $ docker build -t="img-postgis:0.1" .
    

## run

run as current user with given data-directory and custom config-file

    $ docker run --rm -ti \
    --name postgis \
    -p 5432:5432 \
    --user "$(id -u):$(id -g)" \
    -v /etc/passwd:/etc/passwd:ro \
    -v /media/mapdata/pgdata_henry:/media/mapdata/pgdata_henry \
    -v /home/henry/dev/docker/postgis/postgis-osm.conf:/etc/postgresql/postgresql.conf \
    -e PGDATA=/media/mapdata/pgdata_henry \
    img-postgis:0.8 -c 'config_file=/etc/postgresql/postgresql.conf'

## postgres tuning



## References
* 
