Rails.application.configure do
  config.cache_classes = false
  config.eager_load = false
  config.consider_all_requests_local = true
  if Rails.root.join('tmp/caching-dev.txt').exist?
    puts 'INIT CACHE DEV ACTIVATED'
    config.action_controller.perform_caching = false

    config.cache_store = :memory_store
  else
    puts 'INIT CACHE DEV DISABLE'
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.perform_caching = false
  config.active_support.deprecation = :log
  config.active_record.migration_error = :page_load
  config.assets.debug = true
  config.assets.quiet = true
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker

  config.lead_api_paccname = ENV['LEAD_API_PACCNAME']
  config.lead_api_pguid = ENV['LEAD_API_PGUID']
  config.lead_api_ppartner = ENV['LEAD_API_PPARTNER']
  config.lead_api_access_token = ENV['LEAD_API_ACCESS_TOKEN']
  config.lead_api_base_uri = ENV['LEAD_API_URI']
end
