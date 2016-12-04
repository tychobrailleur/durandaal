-module(durandaal).
-include_lib("amqp_client/include/amqp_client.hrl").
-export([start_link/0, pouet/1]).

start_link() ->
    {ok, Pid} = gen_event:start_link(),
    register(durandaal_handler, Pid),
    io:format("Pid = ~p~n", [Pid]),
    gen_event:add_handler(Pid, durandaal_events, []),
    {ok, Pid}.

pouet(Pid) ->
    gen_event:notify(Pid, pouet),
    start_listening().


start_listening() ->
    {ok, Connection} = amqp_connection:start(#amqp_params_network{}),
    {ok, Channel} = amqp_connection:open_channel(Connection),
    Declare = #'queue.declare'{queue = <<"queue.duran">>, durable = true },
    #'queue.declare_ok'{queue = Q} = amqp_channel:call(Channel, Declare),

    Sub = #'basic.consume'{queue = Q},
    #'basic.consume_ok'{} = amqp_channel:call(Channel, Sub),
    listen_queue(Channel).


listen_queue(Channel) ->
    receive
        #'basic.consume_ok'{} ->
            listen_queue(Channel);

        #'basic.cancel_ok'{} ->
            ok;

        {#'basic.deliver'{delivery_tag = Tag}, Content} ->
            #'amqp_msg'{ payload = Payload } = Content,
            io:format("Content = ~p.~n", [Payload]),
            amqp_channel:cast(Channel, #'basic.ack'{delivery_tag = Tag}),
            gen_event:notify(whereis(durandaal_handler), {incoming, { Payload }}),
            listen_queue(Channel)
    end.
