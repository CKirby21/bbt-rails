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
#     Team.where("name LIKE ?", "%Stupid%")
#     EventScore.create(team_id: 17, score: 39.5, event_id: 7)
console:
    docker exec -it bbt-rails bash -c "cd /rails && bin/rails console"

# Tail the logs
log:
    docker logs -f bbt-rails

# Copy source code to raspberry pi. Skip sqlite3 files. 
copy:
    rsync -azP --exclude "*.sqlite3" "../bbt-rails" ckirby@pi24.local:/home/ckirby/

# Copy database from prod machine to tmp location
backupdb:
    ssh -t ckirby@pi24.local 'cp ~/bbt-rails/storage/production.sqlite3 /tmp/production-$(date +%Y%m%d_%H%M%S).sqlite3 && ls /tmp/production-*.sqlite3'

# Copy database from prod machine to dev machine
downloaddb: backupdb
    scp 'ckirby@pi24.local:~/bbt-rails/storage/production.sqlite3' storage/development.sqlite3

# Copy database from dev machine to prod machine
uploaddb: backupdb
    scp storage/development.sqlite3 'ckirby@pi24.local:~/bbt-rails/storage/production.sqlite3'

