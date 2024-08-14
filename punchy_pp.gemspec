# frozen_string_literal: true

require_relative "lib/punchy_pp/version"

Gem::Specification.new do |spec|
  spec.name = "punchy_pp"
  spec.version = PunchyPP::VERSION
  spec.authors = ["Fernando Martínez"]
  spec.email = ["F-3r@users.noreply.github.com"]

  spec.summary = "The puts debugguerer's indispensable companion"
  spec.description = "Are you a puts debuguerer too? Tired of playing 'Where's Waldo' with your `puts`? Sick of losing and forgeting where the heck you've _put_ them in your code? or diying of boredom while scrolling through and endless pit of uneventful logs? If any of those is yes, then, my dear friend, I've got you some PunchyPP!"
  spec.homepage = "https://github.com/sinaptia/punchy_pp"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.5.0"

  spec.metadata["homepage_uri"] = spec.homepage

  gemspec = File.basename(__FILE__)

  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .github appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
