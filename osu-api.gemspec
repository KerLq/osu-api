# frozen_string_literal: true

require_relative "lib/osu/api/version"

Gem::Specification.new do |spec|
  spec.name          = "osu-api"
  spec.version       = Osu::Api::VERSION
  spec.authors       = ["KerLq"]
  spec.email         = ["oussamagaming2001@outlook.de"]

  spec.summary       = "This gem allows to create an oauth login via osu! and use the official osu!apiv2 which are implemented as methods"
  spec.description   = "I'm making a web application using the osu!apiv2. I had to figure out how to use it in Ruby on Rails and implement that into my current project. I came up with the idea to write my own gem to avoid ugly code in my project (+ I had covid and I was bored as hell). It includes an easier way to implement an oauth login via osu! and most(needed) of the current api requests. I hope that you can make use of it :D"
  spec.homepage      = "https://github.com/KerLq"
  spec.required_ruby_version = ">= 2.4.0"

  #spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  #spec.metadata["source_code_uri"] = "https://github.com/KerLq/osu-api"
  #spec.metadata["changelog_uri"] = "https://github.com/KerLq/osu-api/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency "example-gem", "~> 1.0"
    spec.add_dependency "oauth2", '~> 1.2'
  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
