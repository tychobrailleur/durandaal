-module(durandaal_sup).
-behaviour(supervisor).


-export([start_link/0]).
-export([init/1]).

start_link() ->
    supervisor:start_link(?MODULE, []).

init([]) ->
    {ok, {{one_for_one, 1, 5},
          [{console,
            {durandaal, start_link, []},
            permanent, 5000, worker, [durandaal]}]}}.
