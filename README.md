Experimenting with OTP `gen_event` and Mnesia.


## Build

```
rebar3 compile
```

There is also a `Makefile` – whose purpose is (for now) only to call
`rebar3`.


## Run

```
erl -env ERL_LIBS _build/default/lib -eval 'application:ensure_all_started(durandaal).'
```

`Pouet` is the message required by `durandaal_avents` to start
listening to the RabbitMQ.

Sending `Pouet`:

```
1> Pid = <0.63.0>
durandaal:pouet(pid(0,63,0)).
Pouet !
```

Once `Pouet` is sent, durandaal listens on the `queue.duran` RabbitMQ
queue, and processes messages coming on that queue.  Messages are
expected to have the JSON format, and depending on the code they
contain, they perform a given operation on entities called
`accounts`.

## Messages

Messages can be sent to the `queue.duran` queue using the Ruby script
under `test/`, `send_message.rb`.

## Why “Durandaal”?

Because [Excaalibur](https://github.com/tychobrailleur/excaalibur).



# License

GPLv3. (c) 2016 Sébastien Le Callonnec.
