require 'docopt'

class Vanagon
  class CLI
    class Completion < Vanagon::CLI
      DOCUMENTATION = <<~DOCOPT.freeze
        Usage:
          completion [options]

        Options:
          -h, --help                       Display help
          -s, --shell SHELL                Specify shell for completion script [default: bash]
      DOCOPT

      def parse(argv)
        Docopt.docopt(DOCUMENTATION, { argv: argv })
      rescue Docopt::Exit => e
        puts e.message
        exit 1
      end

      def run(options)
        shell = options[:shell].downcase.strip
        completion_file = File.expand_path(File.join('..', '..', '..', '..', 'extras', 'completions', "vanagon.#{shell}"), __FILE__)

        if File.exist?(completion_file)
            puts completion_file
            exit 0
        else
            puts "Could not find completion file for '#{shell}': No such file #{completion_file}"
            exit 1
        end
      end

      def options_translate(docopt_options)
        translations = {
          '--shell' => :shell,
        }
        return docopt_options.map { |k, v| [translations[k], v] }.to_h
      end
    end
  end
end
