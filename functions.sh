#!/usr/bin/env bash

console () {
    docker exec -it bbt-rails bash -c "cd /rails && bin/rails console"
}

build () {
    docker build -t bbt-rails .
}

run () {
    docker run -d \
        --restart unless-stopped \
        --volume /home/ckirby/bbt-rails/storage:/rails/storage \
        -p 8080:8080 \
        -e RAILS_MASTER_KEY=59dc37fdd4369ff87597ae65d6708589 \
        --name bbt-rails \
        bbt-rails
}

logs () {
    docker logs -f bbt-rails
}

