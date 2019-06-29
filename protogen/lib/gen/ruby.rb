# frozen_string_literal: true

def ruby_gen(protos, root_path, out_path, extra_args)
  system('protoc', '--proto_path', root_path.to_s, '--ruby_out', out_path.to_s,
         *protos, *extra_args)
end
