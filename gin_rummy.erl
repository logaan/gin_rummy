-module(gin_rummy).
-compile([export_all]).

% properties is an ordered_dict()
-record(card, {name, properties}).
-record(game, {player1, player2, deck, discard}).
-record(player, {name, hand}).

setup_database() ->
  io:format("setting up databse~n"),
  mnesia:create_schema( [node()] ),
  mnesia:start(),
  mnesia:create_table( card, [{disc_copies, [node()]},
                              {attributes, record_info(fields, card)}]),
  mnesia:create_table( game, [{disc_copies, [node()]},
                              {attributes, record_info(fields, game)}]).

teardown_database() ->
  io:format("tearing down database~n"),
  mnesia:stop(),
  mnesia:delete_schema( [node()] ).

insert_card( _Card ) ->
  io:format("inserting card~n").

generate_playing_cards() ->
  io:format("generating playing cards~n"),
  [].
