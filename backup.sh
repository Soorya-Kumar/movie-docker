MONGO_HOST="mongodb://mongo:27017"
DATABASE="omdbwebsite"
COLLECTION="movies"

backupDir="/movies/backup"

time=$(date +"%Y-%m-%d_%H-%M-%S")

docker exec -i mongo1 mongodump --uri="$MONGO_HOST/$DATABASE" --collection="$COLLECTION" --out="$backupDir/$time"

