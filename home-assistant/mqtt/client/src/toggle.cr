require "json"
require "mqtt/v3/client"

struct Payload
  include JSON::Serializable

  property name : String
  property unique_id : String

  @[JSON::Field(key: "~")]
  property base_topic : String

  property command_topic : String = "~/set"
  property state_topic : String = "~/state"

  property retain : Bool = true

  def initialize(*, @name, @unique_id, @base_topic)
  end

  def full_configuration_topic : String
    "#{base_topic}/config"
  end

  def full_state_topic : String
    state_topic.sub(/^~/, base_topic)
  end
end

transport = MQTT::Transport::TCP.new("red.csikoste.com", 31142)
client = MQTT::V3::Client.new(transport)

name = "test"
client.connect(username: name, password: "FIXME")

payload = Payload.new(unique_id: name, name: "Test switch", base_topic: "homeassistant/switch/#{name}")

state_channel = Channel(Bool).new

client.subscribe(payload.full_state_topic) do |key, payload|
  # payload is a Bytes slice (to support binary payloads)
  content = String.new(payload)
  state_channel.send(content == "ON")
end

select
when on = state_channel.receive?
  # toggle
  next_state = on ? "OFF" : "ON"
  client.publish(payload.full_state_topic, next_state, retain: true)
when timeout 1.second
  puts "timeout"

  # discovery
  client.publish(payload.full_configuration_topic, payload.to_json)
  client.publish(payload.full_state_topic, "ON", retain: true)
end
