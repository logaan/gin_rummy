#!/usr/bin/env escript

main( _ ) ->
  make:all(),
  gin_rummy:setup_database(),
  [ gin_rummy:insert_card( C ) || C <- gin_rummy:generate_playing_cards() ],
  gin_rummy:teardown_database().


