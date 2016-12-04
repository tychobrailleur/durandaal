Experimenting with OTP `gen_event`.


## Build

```
rebar3 compile
```

## Run

```
erl -env ERL_LIBS _build/default/lib -eval 'application:ensure_all_started(durandaal).'
```

Sending `Pouet`:

```
1> Pid = <0.63.0>
durandaal:pouet(pid(0,63,0)).
Pouet !
```

Once `Pouet` is sent, durandaal listens on the `queue.duran` RabbitMQ queue.

## Why “Durandaal”?

Because [Excaalibur](https://github.com/tychobrailleur/excaalibur).



# License

GPLv3. (c) 2016 Sébastien Le Callonnec.
