#!/usr/bin/env escript

-record(card, {name, properties}).
-record(game, {player1, player2, deck, discard}).
-record(player, {name, hand}).

main(_) ->
  make:files([gin_rummy]),
  gin_rummy:setup_database(),

  io:format("=== All Cards ===~n"),
  lists:map(fun gin_rummy:insert_card/1, gin_rummy:generate_playing_cards()),
  Deck = gin_rummy:new_deck() ,
  [ display_card(C) || C <- Deck ],

  io:format("=== Starting Game ===~n"),
  Game = gin_rummy:start_game("Colin", "Royce"),
  io:format("~p cards in the deck~n", [length(Game#game.deck)]),
  io:format(io_lib:print(Game)),

  gin_rummy:teardown_database().

display_card({card, Name, _Properties}) ->
  io:format("~s~n", [Name]).
