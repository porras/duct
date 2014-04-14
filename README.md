# Duct [![Build Status](https://travis-ci.org/porras/duct.png?branch=master)](https://travis-ci.org/porras/duct)

![Duct Tape, By Evan-Amos, via Wikimedia Commons](http://upload.wikimedia.org/wikipedia/commons/thumb/8/89/Duct-tape.jpg/256px-Duct-tape.jpg)

Duct is a small wrapper around [bundler](http://bundler.io/). It allows you to embed a Gemfile in a script.

## Usecase

Sometimes you write small scripts to do different tasks. Sometimes you store them for future use. Sometimes those
scripts use some gems to do their task (database access, web requests, whatever). So, after some time, you reuse them
and you don't know which version of which gems did you use and you can run into trouble (like with full fledged apps in
the pre-bundler days). That's when you do the obvious workaround: create a directory to store the script together with a
`Gemfile` and a `Gemfile.lock`.

That's a good solution but feels a bit overkill. Duct allows you to embed the `Gemfile` (and the `Gemfile.lock`) in the same file, so it's a single file to store together with others, as a [gist](https://gist.github.com/), etc.

## Installation

Duct is a command line utility, so just install it via rubygems:

    $ gem install duct

## Usage

First, write your `Gemfile` in the data section of your script, after the `__END__` label, and after a `@@ Gemfile`
label:

```ruby
require 'sinatra'

get '/' do
  'Hello, world!'
end

__END__
@@ Gemfile
source 'https://rubygems.org'

gem 'sinatra'
```

(this is very much like the [Sinatra inline templates](http://www.sinatrarb.com/intro.html#Inline%20Templates), and can
in fact be combined with them).

Then, run the script using the `duct` command:

```
$ duct my_script.rb
```

The default action is running the script, checking previously whether dependencies are met, and installing them (via
`bundle install`) if needed. Notice that your script data section will be updated with a section for the `Gemfile.lock`
if needed (beware of conflicts with your editor while you develop the script).

### Passing parameters

If your script expects parameters, just pass them after the filename:

```
$ duct my_script.rb param1 param2
```

### Updating the bundle

You can run any of the `bundle` subcommands (mainly `update`, with or without a gem name, but also `outdated`, `check`,
`list`, `show` and [all the rest](http://bundler.io/v1.5/man/bundle.1.html#PRIMARY-COMMANDS)) passing them *before* the
filename:

```
$ duct update sinatra my_script.rb
```

Remember that updating the bundle will update the `Gemfile.lock` section in your script, so remember to save those changes.

### Using Duct in shebangs

Under Unix-like operating systems, you can instruct the program loader to use Duct to run your script. Just put the following [shebang](http://en.wikipedia.org/wiki/Shebang_(Unix)) in the first line of your script:

```ruby
#!/usr/bin/env duct # ruby
```
and add execute permissions to your script:

```zsh
chmod +x my_script
```

This gives you the ability to treat your script as an executable that, once in your $PATH, to execute it directly.


### Using the script data

Duct will ignore the part of the data section **before** the first `@@ XYZ` label (and the sections with other labels
than `@@ Gemfile` and `@@ Gemfile.lock`, as it was mentioned for the Sinatra inline templates case), so you can still
use that ruby feature, but you will need to make sure your script handles and ignores the `Gemfile` and `Gemfile.lock`
sections, of course.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## License

Released under the MIT License, Copyright (c) 2014 Sergio Gil.
