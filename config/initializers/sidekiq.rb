require 'sidekiq'
require 'sidekiq/web'

# Basic authentication for Sidekiq dashboard
Sidekiq::Web.use(Rack::Auth::Basic) do |user, password|
  Rack::Utils.secure_compare(::Digest::SHA256.hexdigest(user), ::Digest::SHA256.hexdigest(ENV["SIDEKIQ_USER"])) &
  Rack::Utils.secure_compare(::Digest::SHA256.hexdigest(password), ::Digest::SHA256.hexdigest(ENV["SIDEKIQ_PASSWORD"]))
end

Sidekiq.configure_server do |config|
  config.logger = Sidekiq::Logger.new($stdout)
  config.logger.level = Logger::WARN
end
