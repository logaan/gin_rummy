-module(gin_rummy).
-include_lib("stdlib/include/qlc.hrl").
-compile([export_all]).

% properties is an ordered_dict()
-record(card, {name, properties}).
-record(game, {player1, player2, deck, discard}).
-record(player, {name, hand}).

setup_database() ->
  mnesia:create_schema( [node()] ),
  mnesia:start(),
  mnesia:create_table( card, [{disc_copies, [node()]},
                              {attributes, record_info(fields, card)}]),
  mnesia:create_table( game, [{disc_copies, [node()]},
                              {attributes, record_info(fields, game)}]).

teardown_database() ->
  mnesia:stop(),
  mnesia:delete_schema( [node()] ).

insert_card( Card ) ->
  Fun = fun() -> mnesia:write( Card ) end,
  mnesia:transaction( Fun ).

all_cards() ->
  Fun = fun() -> qlc:e(qlc:q([ C || C <- mnesia:table(card) ])) end,
  {atomic, Cards} = mnesia:transaction( Fun ),
  Cards.

random_card() ->
  Cards = all_cards(),
  lists:nth(random:uniform(length(Cards)), Cards).

generate_playing_cards() ->
  Suites = ["Hearts", "Diamonds", "Spades", "Clubs"],
  Values = ["King", "Queen", "Jack", "Ten", "Nine", "Eight", "Seven", "Six",
    "Five", "Four", "Three", "Two", "Ace"],
  [ #card{
      name = string:join([V, "of", S], " "),
      properties = [{suite, S}, {value, V}]
    } || S <- Suites, V <- Values ].
