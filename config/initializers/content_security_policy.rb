# Be sure to restart your server when you modify this file.

Rails.application.configure do
  config.content_security_policy do |policy|
    policy.default_src :self
    policy.font_src    :self, :data
    policy.img_src     :self, :https, :data
    policy.object_src  :none
    # Nonces allow the existing inline scripts/styles to work safely.
    # 'unsafe-inline' is ignored by browsers that support nonces.
    policy.script_src  :self, :https
    policy.style_src   :self, :https
    # Razorpay checkout loads from checkout.razorpay.com
    policy.connect_src :self, "https://checkout.razorpay.com", "https://lumberjack.razorpay.com"
    policy.frame_src   "https://api.razorpay.com", "https://checkout.razorpay.com"
  end

  # Generate a per-request nonce for inline scripts and styles.
  config.content_security_policy_nonce_generator = ->(request) { request.session.id.to_s }
  config.content_security_policy_nonce_directives = %w[script-src style-src]
end
