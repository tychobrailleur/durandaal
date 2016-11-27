-module(durandaal_app).
-behaviour(application).

-export([start/2, stop/1]).


start(_Type, _Args) ->
    durandaal_sup:start_link().

stop(_) ->
    ok.
