# Approval2

A trivial implementation of the 4 eyes principle. All record actions require an approval to take effect.

 
## Installation

Add this line to your application's Gemfile:

```ruby
gem 'approval2'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install approval2

## Usage

Models that need an approval, should have the standard approval columns (can be added by included t.approval_columns) and should include include Approval2::ModelAdditions in the class.

Doing so adds the following columns to the model

1. approval_status
2. approved_version
3. approved_id
4. last_action

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/approval2. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

