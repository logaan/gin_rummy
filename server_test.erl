-module(server_test).
-behaviour(gen_server).
%% gen_server callbacks
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,terminate/2, code_change/3]).
-compile(export_all).

%%====================================================================
%% Example usage
%%====================================================================
%% 1> c(server_test).
%% {ok,server_test}
%% 2> {ok, Pid} = server_test:start().
%% {ok,<0.38.0>}
%% 3> gen_server:call(Pid, joke).
%% lol

%%====================================================================
%% Methods we can not worry about for now and just return the default values
%%====================================================================
init([]) -> {ok, null}.
handle_cast(_Msg, State) -> {noreply, State}.
handle_info(_Info, State) -> {noreply, State}.
terminate(_Reason, _State) -> ok.
code_change(_OldVsn, State, _Extra) -> {ok, State}.

%%====================================================================
%% The handle_call methods to deal with the methods
%%====================================================================
handle_call(stop, _From, State) ->
  {stop, normal, State };
 
handle_call(joke, _From, State) ->
    {reply, lol, State}.

%%====================================================================
%% Useful methods for stopping and starting our service
%%====================================================================
start() -> gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).
stop() -> gen_server:call(?MODULE, stop).

