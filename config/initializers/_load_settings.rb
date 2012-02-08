# Load application settings from config/settings.yml
settings_yml = HashWithIndifferentAccess.new(YAML.load_file(Rails.root.join('config', 'settings.yml')))

[:twitter, :facebook, :linked_in].each do |provider|
 [:key, :secret].each do |sub|
   settings_yml[:common][:auth_credentials][provider][sub] = ENV["#{provider}_#{sub}"]
 end
end
[:hoptoad,:secret_token,:session_cookie_key].each do |sub|
  settings_yml[:common][sub] = ENV[sub.to_s]
end

merged_settings = settings_yml['common']
merged_settings.deep_merge!(settings_yml[Rails.env]) if settings_yml.has_key?(Rails.env)

SETTINGS = merged_settings
