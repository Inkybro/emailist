# EmailList

`email_list` is a wrapper around Ruby Array, and is meant to assist in managing a list of email addresses. 

`email_list` automatically attempts to clean invalid emails as they're added, and maintains uniqueness of your list. This is good for parsing emails, where you may end up with some invalid characters, or extra, unwanted bit of text on the beginnings/ends of the emails). While there are some caveats using `email_list`, as long as you don't need and/or expect 100% accuracy, then you should be fine. `email_list` tries its hardest to adhere to the RFC specs for emails, and checks validity of TLDs against ICANN. 

This is just a small project I built for myself. I was building a simple parser to grab emails from a bunch of files. I decided I'd pull it out into its own gem, as I can see it being useful in other cases. Anyway, the code could certainly be a *lot* better, I only spent a couple of hours on this this morning. I'd love to improve this further, so pull requests are **very** welcome.

## Installation

Add this line to your application's Gemfile:

    gem 'email_list'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install email_list

## Usage

Make sure you require...

		require 'email_list'

Adding and removing emails is very easy:

		emails = EmailList.new
		emails.add('bob.jones@example.com')
		=> ['bob.jones@example.com']
		emails.remove('bob.jones@example.com')
		=> []

Uniqueness is automatically maintained:

		emails = EmailList.new
		emails.add('fred.smith@example.com')
		=> ['fred.smith@example.com']
		emails.add('fred.smith@example.com')
		=> ['fred.smith@example.com']

Invalid emails are attempted to be cleaned:

		emails = EmailList.new
		emails.add('.bob.jones@example.com')
		=> ['bob.jones@example.com']
		emails.add('fred.smith@example.com.')
		=> ['fred.smith@example.com']

Finally, invalid TLDs raise `EmailList::InvalidTLD`:

		emails = EmailList.new
		emails.add('bob.jones@fooo.baar')
		=> # raises EmailList::InvalidTLD

## Ideas For Improvement

1. Some kind of "best-guess" algorithm that can take invalid TLDs and find the most likely intended TLD (e.g. I'm getting some emails from my parser that have an 'E', like 'bob.jones@blah.comE' -- this clearly is supposed to be '.com'). Perhaps Levenshtein distance could be useful for this.
2. Ping email domains and raise an error when they're unresponsive. Not sure if this is a good idea, though. Might have some negative side effects that I'm not considering.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/email_list/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
