Rails.application.configure do
  config.cache_classes = true
  config.eager_load = true
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true
  config.read_encrypted_secrets = true
  config.public_file_server.enabled = ENV['RAILS_SERVE_STATIC_FILES'].present?
  config.assets.js_compressor = Uglifier.new(harmony: true)
  config.assets.compile = false
  config.log_level = :debug
  config.log_tags = [ :request_id ]
  config.action_mailer.perform_caching = false
  config.i18n.fallbacks = true
  config.active_support.deprecation = :notify
  config.log_formatter = ::Logger::Formatter.new

  if ENV["RAILS_LOG_TO_STDOUT"].present?
    logger           = ActiveSupport::Logger.new(STDOUT)
    logger.formatter = config.log_formatter
    config.logger    = ActiveSupport::TaggedLogging.new(logger)
  end

  config.active_record.dump_schema_after_migration = false

  config.lead_api_paccname = ENV['LEAD_API_PACCNAME']
  config.lead_api_pguid = ENV['LEAD_API_PGUID']
  config.lead_api_ppartner = ENV['LEAD_API_PPARTNER']
  config.lead_api_access_token = ENV['LEAD_API_ACCESS_TOKEN']
  config.lead_api_base_uri = ENV['LEAD_API_URI']
end
