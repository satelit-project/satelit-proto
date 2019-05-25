#!/usr/bin/env ruby
# frozen_string_literal: true

require 'pathname'

require_relative 'lib/args'
require_relative 'lib/config'
require_relative 'lib/lang_gen'

options = parse_args
if options[:project].nil? || options[:language].nil? || options[:out_dir].nil?
  warn('Required arguments are missing. Try --help to lear more.')
  exit(false)
end

out = Pathname.new(options[:out_dir]).expand_path.cleanpath
unless out.directory?
  warn "Output directory does not exists: #{out}"
  exit(false)
end

root_path = Pathname.new(__dir__) + '..'
config = config_for_project(options[:project], root_path)

generator = generator_for_lang(options[:language])
generator.call(config.protos, root_path, out)
