# NatsStreamingListener

This gem implements functionality of nats-listener with nats streaming.
## Installation

Add this line to your application's Gemfile:

```ruby
gem 'nats_streaming_listener'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install nats_streaming_listener

## Usage

### Creating client
```ruby
NatsStreamingListener::Client.current = NatsStreamingListener::Client.new(
  logger: Ougai::Logger.new(STDOUT),
  skip: false,
  catch_errors: true,
  catch_provider: Rollbar
)
```
All arguments are optional.
`logger` - logger that you can pass to application. It will be called to debug messages.
`skip` - skip calls. Useful for tests
`catch_errors` - catch errors, log them and pass to `catch_provider`
`catch_provider` - provider that is called when error occurs, e.g. Rollbar.

### Establishing connection
```ruby
NatsListener::Client.current.establish_connection(
    service_name: [YOUR SERVICE NAME], 
    nats: { servers: [NATS_SERVERS_URLS] }, # Options passed to nats connector
    cluster_name: [YOUR_CLUSTER_NAME], # Cluster of nats-streaming that you're connecting to
    client_id: [CLIENT_ID] # Id of a client(nats-streaming works with unique client_id)
)
```
### Subscribers

For using subscribers we offer one quite simple way:
1. Create `subscribers` folder.
2. Create your own subscriber derived from `NatsStreamingListener::Subscriber` 
3. Load and subscribe all subscribers, e.g.
```ruby
path = Rails.root.join('app', 'subscribers', '*.rb')

Dir.glob(path) do |entry|
  entry.split('/').last.split('.').first.camelize.constantize.new.subscribe
end
```

#### Protobuf strategy
By default all nats-streaming messages are processed with protobuf. But if you want - you can use our own small wrapper that handles some info and pass it into nats-streaming.
```ruby
2.3.3 :006 > require 'nats_streaming_listener'
=> true
2.3.3 :006 > m = NatsStreaming::NatsMessage.new(sender_service_name: 'ololo', receiver_action_name: 'ololo1', receiver_action_parameters:[1,2,3].map(&:to_s), message_timestamp: Time.now.utc.to_i, transaction_id: 'unique')
 => #<NatsListener::NatsMessage sender_service_name="ololo" receiver_action_name="ololo1" receiver_action_parameters=["1", "2", "3"] message_timestamp=1538902717 transaction_id="unique"> 
2.3.3 :007 > m.serialize
 => "\n\x05ololo\x12\x06ololo1\x1A\x011\x1A\x012\x1A\x013 \xBD\x95\xE7\xDD\x05*\x06unique" 
```


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/nats_streaming_listener. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the NatsStreamingListener project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/nats_streaming_listener/blob/master/CODE_OF_CONDUCT.md).
