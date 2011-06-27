unless Capistrano::Configuration.respond_to?(:instance)
  abort "capistrano/git/tags requires Capistrano 2"
end

require 'capistrano'

Capistrano::Configuration.instance.load do

  after  "deploy:restart", "git:tags:push_deploy_tag"
  before "deploy:cleanup", "git:tags:cleanup_deploy_tag"

  namespace :git do

    namespace :tags do

      def tag_format(options = {})
        tag_format = git_tag_format || ":rails_env_:release"
        tag_format = tag_format.gsub(":rails_env", options[:rails_env] || rails_env)
        tag_format = tag_format.gsub(":release",   options[:release]   || "")
        tag_format
      end

      desc "Place release tag into Git and push it to server."
      task :push_deploy_tag do
        user = `git config --get user.name`
        email = `git config --get user.email`

        puts `git tag #{tag_format(:release => release_name)} #{revision} -m "Deployed by #{user} <#{email}>"`
        puts `git push --tags`
      end

      desc "Remove deleted release tag from Git and push it to server."
      task :cleanup_deploy_tag do
        count = fetch(:keep_releases, 5).to_i
        if count >= releases.length
          logger.important "no old release tags to clean up"
        else
          logger.info "keeping #{count} of #{releases.length} release tags"

          tags = (releases - releases.last(count)).map { |release| tag_format(:release => release) }

          tags.each do |tag|
            `git tag -d #{tag}`
            `git push origin :refs/tags/#{tag}`
          end
        end
      end

    end

  end

end