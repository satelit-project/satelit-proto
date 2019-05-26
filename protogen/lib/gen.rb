# frozen_string_literal: true

require_relative 'gen/rust'

def generator_for_lang(lang)
  unless lang == 'rust'
    warn "Language #{lang} is not supported"
    exit(false)
  end

  method(:rust_gen)
end
