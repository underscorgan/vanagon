require 'docopt'

class Vanagon
  class CLI
    class Completion < Vanagon::CLI
      DOCUMENTATION = <<~DOCOPT.freeze
        Usage:
          completion [--help]

        Options:
          -h, --help                       Display help
          -s, --shell                      Specify shell for completion script [default: bash] 
      DOCOPT

      def parse(argv)
        Docopt.docopt(DOCUMENTATION, { argv: argv })
      rescue Docopt::Exit => e
        puts e.message
        exit 1
      end

      def run(_)
    
      end
    end
  end
end
