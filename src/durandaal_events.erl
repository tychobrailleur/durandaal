-module(durandaal_events).
-behaviour(gen_event).

-include("durandaal.hrl").
-include_lib("stdlib/include/qlc.hrl").

%% Value of signal that triggers the RabbitMQ listening.
-define(POUET, pouet).

-export([init/1, handle_event/2,handle_call/2, handle_info/2, terminate/2, code_change/3]).

init([]) ->
    setup_db(),
    {ok, []}.

setup_db() ->
    mnesia:create_schema([node()]),
    mnesia:start(),
    mnesia:create_table(agent, [ { disc_copies, [node()] },
                                 { record_name, agent },
                                 { attributes, record_info(fields, agent) }
                               ]),
    mnesia:create_table(account, [ { disc_copies, [node()] },
                                   { record_name, account },
                                   { attributes, record_info(fields, account) }
                                 ]).

handle_event(?POUET, State) ->
    io:format("Pouet !~n"),
    {ok, State};
handle_event({ incoming, { Payload } }, State) ->
    Parsed = jsx:decode(Payload, [return_maps]),
    Code = maps:get(<<"code">>, Parsed),
    process_code(Code, Parsed),
    {ok, State};
handle_event(_, State) ->
    {ok, State}.


handle_call(_, State) ->
    {ok, ok, State}.

handle_info(_, State) ->
    {ok, State}.


terminate(_, State) ->
    mnesia:stop(),
    {ok, State}.

code_change(_, State, _) ->
    {ok, State}.


process_code(<<"F111">>, Parsed) ->
    Account = #account{
                 id=uuid:to_string(uuid:uuid4()),
                 agent_id=maps:get(<<"agent_id">>, Parsed),
                 contract_id=maps:get(<<"number">>, Parsed),
                 name=maps:get(<<"name">>, Parsed),
                 date_created=erlang:monotonic_time()},
    mnesia:transaction(fun() -> mnesia:write(Account) end),
    io:format("Creating!~n");

%% Operational code, list all accounts.
process_code(<<"O001">>, _) ->
    A = do(qlc:q([ A || A <- mnesia:table(account) ])),
    lists:foreach(fun(Acc) -> io:format("Account: ~p~n", [Acc]) end, A);

process_code(Unknown, _) ->
    io:format("Unknown code ~s.~n", [Unknown]).

%% Shamelessly borrowed from Joe Armstrong's “Programming Erlang”.
do(Q) ->
    { atomic, Val } = mnesia:transaction(fun() -> qlc:e(Q) end),
    Val.
