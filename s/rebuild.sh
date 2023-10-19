PORT=1111
NAME=ashyria
WHEN=$(date +%s)

echo "Building the production container..."

docker build -t $NAME:latest -t$NAME:$WHEN .

echo "Checking for existing container..."

if [ -n "$(docker ps -a -q -f name=$NAME)" ]; then
    echo "Found running container. Attempting to stop it."
    docker stop $NAME
fi

echo "Running docker container..."

docker run -d \
    --name $NAME \
    -v asteria_accounts:/home/asteria/accounts \
    -v asteria_backup:/home/asteria/backup \
    -v asteria_log:/home/asteria/log \
    -v asteria_data:/home/asteria/data \
    -v asteria_zones:/home/asteria/zones \
    -p $PORT:1111 \
    --restart=on-failure $NAME:latest