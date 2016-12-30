require 'bunny'

conn = Bunny.new(hostname: 'localhost')
conn.start

ch = conn.create_channel
q = ch.queue('queue.duran', durable: true)

data =<<DATA
{
  "code": "F111",
  "number": "5000030",
  "name": "Hector Berlioz",
  "agent_id": 583
}
DATA

ch.default_exchange.publish(data, routing_key: q.name)
#ch.default_exchange.publish('{"code": "O001"}', routing_key: q.name)

conn.close
