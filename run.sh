#!/usr/bin/env bash

ruby --version
bin/rails --version

# Set production environment
RAILS_ENV="production"
BUNDLE_DEPLOYMENT="1"
BUNDLE_PATH="/usr/local/bundle"
BUNDLE_WITHOUT="development"

# Precompile bootsnap code for faster boot times
# RUN bundle exec bootsnap precompile app/ lib/

# Precompiling assets for production without requiring secret RAILS_MASTER_KEY
# RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

# Run and own only the runtime files as a non-root user for security
# RUN groupadd --system --gid 1000 rails && \
#     useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
#     chown -R rails:rails db log storage tmp
# USER 1000:1000

# Entrypoint prepares the database.
# ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# EXPOSE 80
./bin/rails server -b 0.0.0.0 -p 3000
