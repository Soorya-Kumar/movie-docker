FROM mongo:latest

WORKDIR /movie
COPY . /movie

RUN apt-get update && \
    apt-get install -y jq && \
    apt-get clean && \
    chmod +x /movie/main.sh

EXPOSE 27017

CMD ["./main.sh"]
