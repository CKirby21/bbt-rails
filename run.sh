#!/usr/bin/env bash

# Set production environment
export RAILS_ENV="production"
# export BUNDLE_DEPLOYMENT="1"
# export BUNDLE_PATH="/usr/local/bundle"
# export BUNDLE_WITHOUT="development"
RAILS_MASTER_KEY=$(cat config/master.key)
export RAILS_MASTER_KEY

# Precompile bootsnap code for faster boot times
# RUN bundle exec bootsnap precompile app/ lib/

# Precompiling assets for production without requiring secret RAILS_MASTER_KEY
# RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

# Run and own only the runtime files as a non-root user for security
# RUN groupadd --system --gid 1000 rails && \
#     useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
#     chown -R rails:rails db log storage tmp
# USER 1000:1000
#
CLOUDFLARE_IPS="173.245.48.0/20 103.21.244.0/22 103.22.200.0/22 103.31.4.0/22 141.101.64.0/18 108.162.192.0/18 190.93.240.0/20 188.114.96.0/20 197.234.240.0/22 198.41.128.0/17 162.158.0.0/15 104.16.0.0/13 104.24.0.0/14 172.64.0.0/13 131.0.72.0/22"

for IP in $CLOUDFLARE_IPS; do
    iptables -I INPUT -p tcp -m multiport --dports http,https -s "$IP" -j ACCEPT
done

sudo socat TCP-LISTEN:80,reuseaddr,fork TCP:127.0.0.1:3000 &

# Entrypoint prepares the database.
# ENTRYPOINT ["/rails/bin/docker-entrypoint"]

./bin/rails db:migrate
./bin/rails server -b 0.0.0.0 -p 3000 -e "$RAILS_ENV"
