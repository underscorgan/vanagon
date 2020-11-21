require 'vanagon/cli/list'
##
## Ignore the CLI calling 'exit'
##
RSpec.configure do |rspec|
  rspec.around(:example) do |ex|
    begin
      ex.run
    rescue SystemExit => e
      puts "Got SystemExit: #{e.inspect}. Ignoring"
    end
  end
end

describe Vanagon::CLI::List do
  let(:cli) { Vanagon::CLI::List.new }
	describe "#output" do
		let(:list) { ['a', 'b', 'c'] }
		it "returns an array if space is false" do
			expect(cli.output(list, false)).to eq(list)
    end

    it "returns space separated if space is true" do
			expect(cli.output(list, true)).to eq("a b c")
    end
	end

  describe "#run" do
    let(:options_empty) { {} }
    let(:projects){ ['foo', 'bar', 'baz']}
    let(:platforms){ ['a', 'b', 'c']}
    let(:output_both){
"- Projects
foo
bar
baz

- Platforms
a
b
c
" }
    it "prints projects and platforms with no options passed" do
      expect(Dir).to receive(:children).with("#{File.join(Dir.pwd, 'configs', 'projects')}").and_return(projects)
      expect(Dir).to receive(:children).with("#{File.join(Dir.pwd, 'configs', 'platforms')}").and_return(platforms)
      expect do
        cli.run(options_empty)
      end.to output(output_both).to_stdout
    end
  end
end
