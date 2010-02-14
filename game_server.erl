-module(game_server).
-behaviour(gen_server).
%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,terminate/2, code_change/3]).
-export([start/2, stop/0]).
% -compile(export_all).

%%====================================================================
%% Example usage
%%====================================================================
%% 1> c(game_server).
%% {ok,game_server}
%% 2> {ok, Pid} = game_server:start().
%% {ok,<0.38.0>}
%% 3> gen_server:call(Pid, game_state).
%% {game_state, {...}}

init([Player1Name, Player2Name]) ->
  gin_rummy:setup_database(),
  Game = gin_rummy:start_game(Player1Name, Player2Name),
  {ok, Game}.

handle_cast(_Msg, State) -> {noreply, State}.

handle_info(_Info, State) -> {noreply, State}.

terminate(_Reason, _State) -> ok.

code_change(_OldVsn, State, _Extra) -> {ok, State}.

handle_call(stop, _From, State) ->
  {stop, normal, State };
 
handle_call(game_state, _From, State) ->
    {reply, {game_state, State}, State}.

start(Player1Name, Player2Name) ->
  gen_server:start_link({local, ?MODULE}, ?MODULE, [Player1Name, Player2Name], []).

stop() ->
  gen_server:call(?MODULE, stop).

