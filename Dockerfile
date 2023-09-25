FROM mongo:latest

WORKDIR /movie
COPY . /movie

RUN sudo apt-get install jq #install the jq tool
EXPOSE 27017 

CMD["./main.sh"]
