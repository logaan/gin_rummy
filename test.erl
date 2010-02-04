#!/usr/bin/env escript

main( _ ) ->
  make:files([gin_rummy]),
  gin_rummy:setup_database(),

  io:format("=== All Cards ===~n"),
  lists:map(fun gin_rummy:insert_card/1, gin_rummy:generate_playing_cards()),
  [ display_card( C ) || C <- gin_rummy:all_cards() ],

  io:format("=== Random Cards ===n"),
  display_card(gin_rummy:random_card()),
  display_card(gin_rummy:random_card()),
  display_card(gin_rummy:random_card()),

  gin_rummy:teardown_database().

display_card( {card, Name, _Properties} ) ->
  io:format("~s~n", [Name]).
