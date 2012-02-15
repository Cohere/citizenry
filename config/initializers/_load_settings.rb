# Load application settings from config/settings.yml
settings_yml = HashWithIndifferentAccess.new(YAML.load_file(Rails.root.join('config', 'settings.yml')))

[:twitter, :facebook, :linked_in].each do |provider|
  [:key, :secret].each do |sub|
    settings_yml[:common][:auth_credentials][provider][sub] = ENV["#{provider}_#{sub}"]
  end
end
[:access_key_id,:secret_access_key].each do |sub|
  settings_yml[:common][:image_upload][:s3_credentials][sub] = ENV["s3_#{sub}"]
end
[:hoptoad,:secret_token,:session_cookie_key].each do |sub|
  settings_yml[:common][sub] = ENV[sub.to_s]
end
[:address,:domain,:port,:user_name,:password].each do |sub|
  settings_yml['common']['mailer']['smtp_settings'][sub] = ENV["mailer_#{sub}"]
end
merged_settings = settings_yml['common']
merged_settings.deep_merge!(settings_yml[Rails.env]) if settings_yml.has_key?(Rails.env)

SETTINGS = merged_settings

SETTINGS['mailer'] ||= {}

SETTINGS['mailer'].each do |key,value|
  warn "setting mailer #{key}= #{value}"
  ActionMailer::Base.send("#{key}=", value) if ActionMailer::Base.respond_to?("#{key}=")
end
warn ActionMailer::Base.smtp_settings.inspect
