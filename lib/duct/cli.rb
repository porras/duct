require 'duct/runner'

module Duct
  class Cli
    BUNDLER_COMMANDS = %w{
      update
      check
      list
      show
      outdated
      console
      open
      viz
    }

    USAGE = %Q{Commands:
  duct myscript.rb [param1 param2] # Installs bundle included in myscript.rb if needed and
                                   # runs myscript with optional parameters.
  duct update sinatra myscript.rb  # Runs specified bundler command on the bundled included
                                   # in myscript, passing the additional parameters. Available
                                   # commands: #{BUNDLER_COMMANDS.join(', ')}.
                                   # Run bundle help for more info.}

    def initialize(args)
      @args = args
    end

    def filename
      command ? @args.last : @args.first
    end

    def command
      @args[0..-2].join(' ') if BUNDLER_COMMANDS.include?(@args.first)
    end

    def params
      command ? [] : @args[1..-1]
    end

    def error?
      !(command || filename)
    end

    def run
      if error?
        puts(USAGE)
        exit(-1)
      end
      runner.run
    end

    private

    def runner
      @runner ||= Duct::Runner.new(self)
    end
  end
end
