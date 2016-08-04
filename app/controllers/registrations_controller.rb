class RegistrationsController < Devise::RegistrationsController
    private
        def sign_up_params
            params.require(:user).permit(:role, :username, :email, :password, :password_confirmation)
        end
end
