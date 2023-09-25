MONGO_HOST="mongodb://mongo:27017"
DATABASE= "omdbwebsite"
COLLECTIONS=("movies" "actors" "Directors" "genre")

OMDB_API_KEY="91602da3"
movname="$1"

omdb_url="http://www.omdbapi.com/?t=$movname&apikey=$OMDB_API_KEY"
response=$(curl -s "$omdb_url")

title=$(echo "$response" | jq -r '.Title')
year=$(echo "$response" | jq -r '.Year')
date=$(echo "$response" | jq -r '.Released')
runtime=$(echo "$response" | jq -r '.Runtime')
director=$(echo "$response" | jq -r '.Director')
actors=$(echo "$response" | jq -r '.Actors')
boxoffice=$(echo "$response" | jq -r '.BoxOffice')
genres=$(echo "$response" | jq -r '.Genre')

image=$(echo "$response" | jq -r '.Poster')
wget -P /home/soorya/Documents/movie/images "$image"


#echo "$title" >> ./trial.txt
#echo "$year" >> ./trial.txt
#echo "$date" >> ./trial.txt
#echo "$runtime" >> ./trial.txt
#echo "$director" >> ./trial.txt
#echo "$actors" >> ./trial.txt
#echo "$boxoffice" >> ./trial.txt

format_json_like() {
    local field="$1"
    local data="$2"
    awk -F',' -v field="$field" '{ for (i=1; i<=NF; i++) printf("{\"%s\":\"%s\"}%s", field, $i, (i<NF ? "," : "")) }' <<< "$data"
}

ACTORS=$(format_json_like "actor" "$actors")
DIRECTORS=$(format_json_like "director" "$director")
GENRES=$(format_json_like "genre" "$genres")

#echo "$ACTORS" >> ./trial.txt
#echo "$DIRECTORS" >> ./trial.txt
#echo "$GENRES" >> ./trial.txt


docker exec -i mongo1 mongo "$MONGO_HOST/$DATABASE" --eval "db.movies.insertOne({ title: '$title', year: '$year', releaseDate: '$date', runtime: '$runtime', director: '$director', actors: '$actors', boxOffice: '$boxoffice' })"


insert_data() {
    local collection_name="$1"
    local data="$2"
    
    docker exec -i mongo1 mongo "$MONGO_HOST/$DATABASE" --eval "db.$collection_name.insertOne($data)"
}

for actor in "${ACTORS[@]}"; do
    insert_data "actors" "$actor"
done

for director in "${DIRECTORS[@]}"; do
    insert_data "Directors" "$director"
done

for genre in "${GENRES[@]}"; do
    insert_data "genres" "$genre"
done

