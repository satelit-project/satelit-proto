# frozen_string_literal: true

require 'fileutils'

def rust_gen(protos, root_path, out_path)
  project_path = Pathname.new(root_path) + 'protogen/rust'
  proto_args = protos.map { |p| ['--proto', p] }.flatten
  tmp_out = tmp_dir(out_path)

  Dir.chdir(project_path) do
    system('cargo', 'build', '--release')
    system({ 'OUT_DIR' => tmp_out.to_s }, 'cargo', 'run', '--release', '--',
           '--include-path', root_path.to_s, *proto_args)
  end

  modularize_rust(tmp_out)
  cp_dir(tmp_out, out_path)
  FileUtils.rm_r(tmp_out)
end

private

def tmp_dir(parent)
  tmp = Pathname.new(parent) + '.protogen'
  system('rm', '-r', tmp.to_s) if tmp.exist?
  system('mkdir', tmp.to_s)

  tmp
end

def cp_dir(source, target)
  source_all = File.join(source.to_s, '.')
  system('cp', '-a', source_all, target.to_s)
end

def modularize_rust(path)
  modules = {}

  Dir.glob('*.rs', base: path) do |f|
    name = File.basename(f)
    parts = name.split('.')

    modules[parts[0]] ||= []
    modules[parts[0]] << parts[1..].join('.') if parts.count > 2
  end

  generate_modules(modules, path)
end

def generate_modules(modules, path)
  modules.each_key do |mod|
    mod_path = path + mod
    Dir.mkdir(mod_path)
    mod_rs = String.new

    modules[mod].each do |file|
      original = "#{mod}.#{file}"
      mod_rs << "pub mod #{file.partition('.')[0]};\n"
      FileUtils.mv(path + original, path + mod + file)
    end

    File.open(mod_path + 'mod.rs', 'w') { |f| f.write(mod_rs) }
  end
end
