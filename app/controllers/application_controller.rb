class ApplicationController < ActionController::Base
  include Pundit

  # verify_authorized will ensure that authorize is called in a controller action,
  # and verify_policy_scoped will ensure that policy_scope is called,
  # which you did way back when you filtered projects to be displayed on the index
  # action of ProjectController.
  after_action :verify_authorized, except: [:index],
                                   unless: :devise_controller?
  after_action :verify_policy_scoped, only: [:index],
                                      unless: :devise_controller?

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Catch all of these exceptions, wherever they happen
  rescue_from Pundit::NotAuthorizedError, with: :not_authorized

  private

  def not_authorized
    redirect_to root_path, alert: "You aren't allowed to do that."
  end
end
