unless Capistrano::Configuration.respond_to?(:instance)
  abort "capistrano/git/tags requires Capistrano 2"
end

require 'capistrano'

Capistrano::Configuration.instance.load do

  after  "deploy:restart", "git:tags:push_deploy_tag"
  before "deploy:cleanup", "git:tags:cleanup_deploy_tag"

  namespace :git do

    namespace :tags do

      desc "Place release tag into Git and push it to server."
      task :push_deploy_tag do
        user = `git config --get user.name`
        email = `git config --get user.email`

        puts `git tag #{rails_env}_#{release_name} #{revision} -m "Deployed by #{user} <#{email}>"`
        puts `git push --tags`
      end

      desc "Place release tag into Git and push it to server."
      task :cleanup_deploy_tag do
        count = fetch(:keep_releases, 5).to_i
        if count >= releases.length
          logger.important "no old release tags to clean up"
        else
          logger.info "keeping #{count} of #{releases.length} release tags"

          tags = (releases - releases.last(count)).map { |release| "#{rails_env}_#{release}" }

          tags.each do |tag|
            `git tag -d #{tag}`
            `git push origin :refs/tags/#{tag}`
          end
        end
      end

    end

  end

end