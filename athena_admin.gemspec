require_relative "lib/athena_admin/version"

Gem::Specification.new do |spec|
  spec.name        = "athena_admin"
  spec.version     = AthenaAdmin::VERSION
  spec.authors     = [ "Sergio Reyes" ]
  spec.email       = [ "sdreyesg@gmail.com" ]
  spec.homepage    = "https://github.com/BarbaricCorgi/athena_admin"
  spec.summary     = "Ember — a dark-first, mobile-first ActiveAdmin 4 theme."
  spec.description = "Athena restyles ActiveAdmin 4 with the Ember design system: " \
                     "orange/fire accent, monospace numerics, light + dark modes."
  spec.license     = "MIT"
  spec.required_ruby_version = ">= 3.2"

  spec.metadata["homepage_uri"]    = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "railties", ">= 7.1"
  spec.add_dependency "activeadmin", ">= 4.0.0.beta1", "< 5"
end
