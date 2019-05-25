# frozen_string_literal: true

def generator_for_lang(lang)
  unless lang == 'rust'
    warn "Language #{lang} is not supported"
    exit(false)
  end

  method(:rust_gen)
end

def rust_gen(protos, root_path, out_path)
  project_path = Pathname.new(root_path) + 'protogen/rust'
  proto_args = protos.map { |p| ['--proto', p] }.flatten

  Dir.chdir(project_path) do
    system('cargo', 'build', '--release')
    system({ 'OUT_DIR' => out_path.to_s }, 'cargo', 'run', '--',
           '--include-path', root_path.to_s, *proto_args)
  end
end
