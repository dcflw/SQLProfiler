# SQLProfiler - for Rails 5.0+
## Installation

Add this line to your application's Gemfile:

```ruby
gem 'sql_profiler', github: "dcflw/sql_profiler"
```

## Usage
```ruby
res = SQLProfiler.run do
  User.last
end

=> #<SQLProfiler::Result:0x00005618d14c4588 @entries=[{:start=>2021-01-20 13:29:06.381776458 +0100, :finish=>2021-01-20 13:29:06.382921535 +0100, :duration=>1.1451, :query=>"SELECT  \"users\".* FROM \"users\" WHERE \"users\".\"deleted_at\" IS NULL ORDER BY \"users\".\"name\" DESC, \"users\".\"email\" DESC LIMIT $1"}]>
res.total_time
=> 1.1451
res.total_time unit: :s
=> 0.0011451
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
