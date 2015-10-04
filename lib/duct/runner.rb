require 'tmpdir'
require 'stringio'
require 'shellwords'

module Duct
  class Runner
    def initialize(config)
      @config = config
    end

    def file_content
      @file_content ||= File.read(@config.filename).split(/^__END__$/, 2)
    end

    def script
      @script ||= file_content.first
    end

    def data
      @data ||= file_content.last
    end

    def preamble
      @preamble ||= data.split(/^@@\s*(.*\S)\s*$/, 2).first
    end

    def run
      copy_embedded_files
      system "BUNDLE_GEMFILE=#{tempdir}/Gemfile bundle #{@config.command}"
      update_embedded_files
      exec script_command unless @config.command
    end

    def script_command
      filename = @config.filename.shellescape
      params = @config.params.join(' ')
      "BUNDLE_GEMFILE=#{tempdir}/Gemfile bundle exec ruby #{filename} #{params}; rm -rf #{tempdir}"
    end

    private

    def copy_embedded_files
      embedded_files.each do |file, contents|
        IO.write("#{tempdir}/#{file}", contents)
      end
    end

    def update_embedded_files
      contents = script.dup

      contents << "__END__"
      contents << preamble

      Dir.glob("#{tempdir}/*") do |filename|
        contents << "@@ #{File.basename(filename)}\n"
        contents << File.read(filename)
      end

      IO.write(@config.filename, contents)
    end

    def embedded_files
      @embedded_files ||= {}.tap do |files|
        file = nil
        data.each_line do |line|
          if line =~ /^@@\s*(.*\S)\s*$/
            file = ''
            files[$1.to_sym] = file
          elsif file
            file << line
          end
        end
      end
    end

    def tempdir
      @tempdir ||= Dir.mktmpdir
    end
  end
end
