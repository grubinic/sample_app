class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    @title = @user.name
  end

  def new
    @title = "Sign up"
    @user = User.new
  end

  def index
    @users = User.all
  end

  def create
    # request params in html are of the form name="user[email]"
    # rails converts it into hash { :user => {:name => "", :email => ""} }
    @user = User.new(params[:user])
    if @user.save
      # Handle a successful save.
      #flash is a rails var (hash..)
      flash[:success] = "Welcome to the Sample App!"
      # redirect
      redirect_to @user
    else    
      @title = "Sign up"
      render 'new'
    end
  end

end
