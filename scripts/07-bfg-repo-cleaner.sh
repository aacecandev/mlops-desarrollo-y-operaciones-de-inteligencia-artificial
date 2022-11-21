#!/bin/bash

docker run --rm -it -v $(pwd):/tmp --user ${USERNAME} donderom/bfg-repo-cleaner --delete-files .secrets

# El comando anterior nos cambiará al propietario de ciertos directorios y archivos, por lo que
# es necesario reasignar al propietario
chown -R ${USERNAME}:${USERNAME} .

# Ahora tenemos que actualizar los antiguos valores de los punteros HEAD y ejecutar el garbage collector
git reflog expire --expire=now --all && git gc --prune=now --aggressive
