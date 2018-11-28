Rails.application.configure do
  config.cache_classes = true
  config.eager_load = false
  config.public_file_server.enabled = true
  config.public_file_server.headers = {
    'Cache-Control' => "public, max-age=#{1.hour.seconds.to_i}"
  }

  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false
  config.action_dispatch.show_exceptions = false
  config.action_controller.allow_forgery_protection = false
  config.action_mailer.perform_caching = false
  config.action_mailer.delivery_method = :test
  config.active_support.deprecation = :stderr
  config.cache_store = :null_store
  config.active_record.sqlite3.represent_boolean_as_integer = true

  config.lead_api_paccname = 'test_paccname'
  config.lead_api_pguid = 'c5b88f56-00e8-11e8-ba89-0ed5f89f718b'
  config.lead_api_ppartner = 'test_ppartner'
  config.lead_api_access_token = 'test_access_token'
  config.lead_api_base_uri = 'http://test_lead_api/api/v1'
end
