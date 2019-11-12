lib = File.expand_path("lib", __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "tinder/version"

Gem::Specification.new do |spec|
  spec.name    = "tinder_client"
  spec.version = Tinder::VERSION
  spec.authors = ["Patrick Clery"]
  spec.email   = ["patrick.clery@gmail.com"]

  spec.summary     = "This client allow you to login and use your Tinder account"
  spec.description = %q{A client for Tinder written in Ruby}
  spec.homepage    = "https://github.com/patrickclery/tinder_client"
  spec.license     = "MIT"

  spec.metadata["homepage_uri"]    = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "bundler"
  spec.add_dependency "dry-struct"
  spec.add_dependency "dry-types"
  spec.add_dependency "faraday"
  spec.add_dependency "hashdiff"
  spec.add_dependency "rake"
  spec.add_dependency "rspec"
  spec.add_dependency "webmock"
  spec.add_dependency "vcr"
end
