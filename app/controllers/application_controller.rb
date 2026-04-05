class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  stale_when_importmap_changes

  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :phone])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :phone])
  end

  def current_cart
    if current_user
      current_user.cart || current_user.create_cart
    else
      session_cart
    end
  end
  helper_method :current_cart

  private

  def session_cart
    if session[:cart_id]
      Cart.find_by(id: session[:cart_id]) || create_guest_cart
    else
      create_guest_cart
    end
  end

  def create_guest_cart
    cart = Cart.create(session_token: SecureRandom.hex)
    session[:cart_id] = cart.id
    cart
  end
end
