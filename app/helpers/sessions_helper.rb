module SessionsHelper

  def log_in(user)
    session[:user_id] = user.id
  end

  def logged_in?
    !session[:user_id].nil?
  end

  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end

  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  def current_user?(user)
    current_user == user
  end

  def current_user
      if user ||= User.find(session[:user_id])
        @current_user = user
      elsif user ||= User.find(cookies.signed[:user_id])
        if user && user.authenticated?(remember,cookies[:remember_token])
          log_in user
          @current_user = user
        end
      else
        redirect_to login_path
      end 
  end 


  def log_out
    if logged_in?
      forget(current_user)
      @current_user = nil
      session.delete(:user_id)
    end 
  end 

  def location_url
    session[:forwarding_url] = request.original_url if request.get?
  end

  def redirect_hisotry(default)
    redirect_to ( session[:forwarding_url] || default )
    session.delete(:forwarding_url)
  end
end
