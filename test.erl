#!/usr/bin/env escript

% -record(card, {name, properties}).
% -record(game, {player1, player2, deck, discard}).
% -record(player, {name, hand}).

main(_) ->
  make:files([gin_rummy]),

  io:format("=== Setting up database ===~n"),
  % In reality the database will persist and will be shared between servers
  gin_rummy:setup_database(),
  lists:map(fun gin_rummy:insert_card/1, gin_rummy:generate_playing_cards()),

  io:format("=== Starting game server ===~n"),
  {ok, ServerPid} = game_server:start("Colin", "Royce"),
  Game = gen_server:call(ServerPid, game_state),
  gin_rummy:display_game(Game),

  io:format("=== Tearing down database ===~n"),
  gin_rummy:teardown_database().
