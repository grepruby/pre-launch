AppConfig = YAML::load_file(Rails.root.join("config", "config.yml"))[Rails.env]
if AppConfig.blank?
  raise "No Configuraion found for #{Rails.env} environment"
end
