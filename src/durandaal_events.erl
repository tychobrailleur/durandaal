-module(durandaal_events).
-behaviour(gen_event).


-export([init/1, handle_event/2,handle_call/2, handle_info/2, terminate/2, code_change/3]).


init([]) ->
    {ok, []}.


handle_event(pouet, State) ->
    io:format("Pouet !~n"),
    {ok, State};
handle_event(_, State) ->
    {ok, State}.



handle_call(_, State) ->
    {ok, ok, State}.

handle_info(_, State) ->
    {ok, State}.


terminate(_, State) ->
    {ok, State}.

code_change(_, State, _) ->
    {ok, State}.
