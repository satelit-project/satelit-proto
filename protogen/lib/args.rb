# frozen_string_literal: true

require 'optparse'

def parse_args
  options = {}

  OptionParser.new do |opts|
    opts.banner = <<~HERE
      Generate sources for your .proto files
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
  end.parse!

  options
end
