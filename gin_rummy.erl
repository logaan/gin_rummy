-module(gin_rummy).
-include_lib("stdlib/include/qlc.hrl").
-include("records.hrl").
-compile([export_all]).

setup_database() ->
  mnesia:delete_schema( [node()] ),
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

new_deck() ->
  Fun = fun() -> qlc:e(qlc:q([ C || C <- mnesia:table(card) ])) end,
  {atomic, Deck} = mnesia:transaction( Fun ),
  shuffle_deck( Deck ).

% This was the original implementation:
% shuffle_deck( Deck ) ->
%   lists:sort( fun( _, _ ) -> random:uniform(2) == 1 end, Deck ).
% But I think calling random_draw/1 will give a better distribution
shuffle_deck( Deck ) ->
  shuffle_deck( [], Deck ).
shuffle_deck( Deck, [] ) ->
  Deck;
shuffle_deck( Deck, OldDeck ) ->
  {RandomCard, NewOldDeck} = random_draw( OldDeck ),
  NewDeck = [RandomCard | Deck],
  shuffle_deck( NewDeck, NewOldDeck ).

random_draw( Deck ) ->
  Card = lists:nth(random:uniform(length(Deck)), Deck),
  NewDeck = lists:delete(Card, Deck),
  {Card, NewDeck}.

draw( [Card | Deck ] ) ->
  {Card, Deck}.
draw( NumberOfCards, Deck ) ->
  lists:split( NumberOfCards, Deck ).

generate_playing_cards() ->
  Suites = ["Hearts", "Diamonds", "Spades", "Clubs"],
  Values = ["King", "Queen", "Jack", "Ten", "Nine", "Eight", "Seven", "Six",
    "Five", "Four", "Three", "Two", "Ace"],
  [ #card{
      name = string:join([V, "of", S], " "),
      properties = [{suite, S}, {value, V}]
    } || S <- Suites, V <- Values ].

start_game( Player1Name, Player2Name ) ->
  Deck1 = new_deck(),
  {Player1Hand, Deck2} = draw( 10, Deck1 ),
  {Player2Hand, Deck3} = draw( 10, Deck2 ),
  Player1 = #player{ name = Player1Name, hand = Player1Hand },
  Player2 = #player{ name = Player2Name, hand = Player2Hand },
  #game{ player1 = Player1, player2 = Player2, deck = Deck3, discard = [] }.
