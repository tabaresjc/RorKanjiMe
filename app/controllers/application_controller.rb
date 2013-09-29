class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include SessionsHelper
  around_filter :user_time_zone, :if => :current_user


  def user_time_zone(&block)
    Time.use_zone(current_user.timezone, &block)
  end

end
