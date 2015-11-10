STRIPE_KEYS = YAML.load_file("#{Rails.root.to_s}/config/stripe_keys.yml")[Rails.env]
