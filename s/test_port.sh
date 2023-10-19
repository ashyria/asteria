PORT=1122
NAME=testport

echo "Building the testport container..."

docker build -t $NAME .

echo "Checking for existing testport..."

if [ -n "$(docker ps -a -q -f name=$NAME)" ]; then
    echo "Found test port container. Attempting to stop and remove it."
    docker stop $NAME
    docker rm -fv $NAME
fi

echo "Removing testport volumes, if they exist..."

docker volume rm testport_accounts testport_backup testport_log testport_data testport_zones

echo "Copying new testport volumes from production..."

# DEST=$PWD/$name$when

# mkdir -p $DEST

for TYPE in accounts backup log data zones; do
    # LOCAL=$DEST/$TYPE
    # mkdir -p $LOCAL
    docker run --rm -v asteria_$TYPE:/source -v testport_$TYPE:/dest alpine ash -c "cd /source > /dev/null; cp -av . /dest > /dev/null"
done

echo "Running docker container..."

docker run -d \
    --name $NAME \
    -v testport_accounts:/home/asteria/accounts \
    -v testport_backup:/home/asteria/backup \
    -v testport_log:/home/asteria/log \
    -v testport_data:/home/asteria/data \
    -v testport_zones:/home/asteria/zones \
    -p $PORT:1111 \
    --restart=on-failure $NAME:latest