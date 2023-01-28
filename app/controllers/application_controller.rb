class ApplicationController < ActionController::Base
<<<<<<< HEAD
  before_action :authenticate_user!
=======
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
  end
>>>>>>> 8f1d96dfe83aaae93162039c1239d786fb146f17
end
