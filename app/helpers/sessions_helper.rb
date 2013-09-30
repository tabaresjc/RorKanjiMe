module SessionsHelper
	def sign_in(user, options = { remember_me: false })
    remember_me = options[:remember_me]    
		remember_token = User.new_remember_token
		
    if remember_me 
      cookies.permanent[:remember_token] = remember_token
    else
      cookies[:remember_token] = remember_token
    end
		
    user.update_attribute(:remember_token, User.encrypt(remember_token))
    self.current_user = user
	end

	def current_user=(user)
		@current_user = user
	end

	def current_user
		remember_token = User.encrypt(cookies[:remember_token])
		@current_user ||= User.find_by(remember_token: remember_token)
	end

	def current_user?(user)
    	user == current_user
  end

  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_url
    end
  end

  def signed_in?
    !current_user.nil?
  end

	def sign_out
		self.current_user = nil
		cookies.delete(:remember_token)
	end

  	def app_name
  		"Kanji Me!"
  	end

	def redirect_back_or(default)
		redirect_to(session[:return_to] || default)
		session.delete(:return_to)
	end

	def store_location
		session[:return_to] = request.url if request.get?
	end

  def format_dt(rawdt)
      rawdt.strftime("%m/%d/%Y %I:%M %p")
  end
end
