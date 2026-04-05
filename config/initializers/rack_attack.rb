class Rack::Attack
  # Throttle login attempts by IP: 5 attempts per 20 seconds
  throttle("logins/ip", limit: 5, period: 20.seconds) do |req|
    req.ip if req.path == "/users/sign_in" && req.post?
  end

  # Throttle login attempts by email: 5 attempts per 20 seconds
  throttle("logins/email", limit: 5, period: 20.seconds) do |req|
    if req.path == "/users/sign_in" && req.post?
      req.params.dig("user", "email").to_s.downcase.gsub(/\s+/, "")
    end
  end

  # Throttle registration by IP: 3 signups per hour
  throttle("registrations/ip", limit: 3, period: 1.hour) do |req|
    req.ip if req.path == "/users" && req.post?
  end

  # Throttle password reset requests by IP: 5 per hour
  throttle("password_resets/ip", limit: 5, period: 1.hour) do |req|
    req.ip if req.path == "/users/password" && req.post?
  end

  # Throttle order placement by IP: 10 per minute
  throttle("orders/ip", limit: 10, period: 1.minute) do |req|
    req.ip if req.path == "/orders/place" && req.post?
  end

  # Throttle AI lace finder by IP: 10 per hour (Claude API calls are expensive)
  throttle("lace_finder/ip", limit: 10, period: 1.hour) do |req|
    req.ip if req.path == "/lace-finder" && req.post?
  end

  # Return 429 with a plain-text body for throttled requests
  self.throttled_responder = lambda do |req|
    [
      429,
      { "Content-Type" => "text/plain" },
      [ "Too many requests. Please try again later." ]
    ]
  end
end
