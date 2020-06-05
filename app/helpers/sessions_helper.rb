module SessionsHelper
  
  # logs in the given user. 
  def log_in(user)
    session[:user_id] = user.id
  end 
  # Remembers a user in a persistent session.
  def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
  end 
    
  
  # Returns the current logged-in user (if any).
  def current_user #defined so we can retrieve the users id on subsequent pages and avoid grabbing the user id multiple times 
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id) #will assign current_user if its nil 
    elsif (user_id = cookies.signed[:user_id])# not a comparison checks if user_id exists while assigning it
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
      
        log_in user
        @current_user = user
      end 
    end 
  end 
  # Returns true if the user is logged in, false otherwise.
  def logged_in?
    !current_user.nil?
  end 
  
  # Forgets persistent session.
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end 
  
  def log_out 
      forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end

end
