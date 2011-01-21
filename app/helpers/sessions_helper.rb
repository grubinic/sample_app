module SessionsHelper
  
  def sign_in(user)
    #digital signature
    cookies.permanent.signed[:remember_token] = [user.id, user.salt]   
    self.current_user = user
  end

  def sign_out
    cookies.delete(:remember_token);
    self.current_user = nil
  end

  def signed_in?
    #method call
    !current_user.nil?
  end

  #overhead? we could just use @ instead of self.current_user
  def current_user=(user)
    @current_user = user
  end

  def current_user
    @current_user ||= user_from_remember_token
  end

  private

  def user_from_remember_token
    # f(*[a,b]) = f(a, b)
    User.authenticate_with_salt(*remember_token)
  end

  def remember_token
    cookies.signed[:remember_token] || [nil, nil]
  end


end
