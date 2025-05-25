default:
  just --list

# Build the container
build:
    docker build -t bbt-rails .

# Cleans up docker
clean:
    docker stop bbt-rails
    docker container remove bbt-rails

# Run the container
run:
    docker run -d \
        --restart unless-stopped \
        --volume /home/ckirby/bbt-rails/storage:/rails/storage \
        -p 8080:8080 \
        -e RAILS_MASTER_KEY="$(cat config/master.key)" \
        --name bbt-rails \
        bbt-rails

# Access the rails console
console:
    docker exec -it bbt-rails bash -c "cd /rails && bin/rails console"

# Tail the logs
log:
    docker logs -f bbt-rails

# Copy source code to raspberry pi. Skip sqlite3 files. 
copy:
    rsync -azP --exclude "*.sqlite3" "../bbt-rails" ckirby@pi24.local:/home/ckirby/

