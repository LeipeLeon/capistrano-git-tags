

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = "capistrano-git-tags"
  s.version     = "0.0.2"
  s.summary     = "Tag your deployed commit to git"
  s.description = <<-EOF
    With every commit tag the local and remote branch with a tag
  EOF

  s.files = ["CHANGELOG.rdoc", "lib/capistrano/git/tags.rb", "MIT-LICENSE", "README.markdown", "Manifest"]

  s.authors     = ["Leon Berenschot"]
  s.email       = ["LeonB@beriedata.nl"]
  s.date        = "2010-05-06"
  s.homepage    = "http://github.com/leipeleon/capistrano-git-tags"

  s.add_dependency("capistrano", [">= 1.0.0"])

  s.has_rdoc = false
end

# WARNING:  no rubyforge_project specified
