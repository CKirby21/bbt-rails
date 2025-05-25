#!/usr/bin/env bash

rsync -azP --exclude "./storage/production.sqlite3" ../bbt-rails ckirby@pi24.local:/home/ckirby/

