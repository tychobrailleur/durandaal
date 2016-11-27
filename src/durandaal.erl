-module(durandaal).
-export([start_link/0, pouet/1]).

start_link() ->
    {ok, Pid} = gen_event:start_link(),
    io:format("Pid = ~p~n", [Pid]),
    gen_event:add_handler(Pid, durandaal_events, []),
    {ok, Pid}.

pouet(Pid) ->
    gen_event:notify(Pid, pouet).
