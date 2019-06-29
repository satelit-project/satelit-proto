# frozen_string_literal: true

require_relative 'gen/rust'
require_relative 'gen/ruby'

def generator_for_lang(lang)
  case lang
  when 'rust'
    method(:rust_gen)

  when 'ruby'
    method(:ruby_gen)

  else
    raise "Language #{lang} is not supported"
  end
end
