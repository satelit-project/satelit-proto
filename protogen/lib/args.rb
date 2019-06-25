# frozen_string_literal: true

require 'optparse'

# @return [Hash<String, String>] parsed program arguments
def parse_args
  options = {}
  opts = make_parser(options)

  args = opts.default_argv.join(' ').split(' -- ')
  opts.default_argv = args[0].split(/\s+/)
  options[:extra] = args[1].split(/\s+/) if args.count > 1

  opts.parse!
  options
end

private

# @return [OptionParser] an options parser
def make_parser(options)
  OptionParser.new do |opts|
    opts.banner = <<~HERE
      Generate sources for your .proto files.

      This is a facade for underlying sources generators. It looks for a specific set of '.proto' files for each
      project and passes it to a generator for specified language. You can pass additional arguments to a generator
      by specifying them after ' -- '. 

      NOTE: You should NOT override paths to '.proto' files or include directory in generators itself!

    HERE

    opts.on('--project PROJECT', 'Target satelit project') do |p|
      options[:project] = p
    end

    opts.on('--language LANG', 'Target programming language') do |l|
      options[:language] = l
    end

    opts.on('--out-dir OUT', 'Output directory') do |o|
      options[:out_dir] = o
    end

    opts.on('-h', '--help', 'Print help message') do
      warn opts
      exit
    end
  end
end
