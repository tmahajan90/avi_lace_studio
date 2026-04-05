module Users
  class RegistrationsController < Devise::RegistrationsController
    protected

    def after_sign_up_path_for(resource)
      root_path
    end

    def after_update_path_for(resource)
      account_profile_path
    end
  end
end
