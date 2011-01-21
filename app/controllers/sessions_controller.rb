class SessionsController < ApplicationController
  def new
    @title = "Sign in"
  end

  def create
    user = User.authenticate(params[:session][:email],
      params[:session][:password])
    if user.nil?
      # flash var designed to be used before redirect - goes in session,
      # flash.now -> goes in 'request attr'
      flash.now[:error] = "Invalid email/password combination."
      @title = "Sign in"
      render 'new'
    else
      # Sign the user in and redirect to the user's show page.
      sign_in(user)
      #or redirect_to user - pff
      redirect_to user_path(user)
    end

  end

  def destroy
    sign_out
    redirect_to root_path
  end

end
