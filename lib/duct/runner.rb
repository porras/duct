require 'tmpdir'
require 'stringio'

module Duct
  class Runner
    def initialize(config)
      @config = config
      @script, @data = File.read(@config.filename).split(/^__END__$/, 2)
      @preamble = @data.split(/^@@\s*(.*\S)\s*$/, 2).first
    end

    def run
      copy_embedded_files
      system "BUNDLE_GEMFILE=#{tempdir}/Gemfile bundle #{@config.command}"
      update_embedded_files
      exec "BUNDLE_GEMFILE=#{tempdir}/Gemfile bundle exec ruby #{@config.filename} #{@config.params.join(' ')}; rm -rf #{tempdir}" unless @config.command
    end

    private

    def copy_embedded_files
      embedded_files.each do |file, contents|
        IO.write("#{tempdir}/#{file}", contents)
      end
    end

    def update_embedded_files
      contents = @script.dup

      contents << "__END__"
      contents << @preamble

      Dir.glob("#{tempdir}/*") do |filename|
        contents << "@@ #{File.basename(filename)}\n"
        contents << File.read(filename)
      end

      IO.write(@config.filename, contents)
    end

    def embedded_files
      @embedded_files ||= {}.tap do |files|
        file = nil
        @data.each_line do |line|
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
