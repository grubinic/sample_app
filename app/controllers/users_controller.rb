class UsersController < ApplicationController
  # call :authenticate function before edit and update actions
  before_filter :authenticate,    :only => [:edit, :update, :index, :destroy]
  before_filter :correct_user,    :only => [:edit, :update]
  before_filter :admin_user,      :only => :destroy
  before_filter :signed_in_user,  :only => [:new, :create]



  def show
    @user = User.find(params[:id])
    @title = @user.name
  end

  def new
    @title = "Sign up"
    @user = User.new
  end

  def index
    @title = "All users"
    @users = User.paginate(:page => params[:page])
  end

  def create
    # request params in html are of the form name="user[email]"
    # rails converts it into hash { :user => {:name => "", :email => ""} }
    @user = User.new(params[:user])
    if @user.save
      # Handle a successful save.
      sign_in(@user);
      #flash is a rails var (hash..)
      flash[:success] = "Welcome to the Sample App!"
      # redirect
      #equiv. to GET user_path(user) - /users/id
      redirect_to @user
    else
      @user.password = ""
      @user.password_confirmation = ""
      @title = "Sign up"
      render 'new'
    end
  end

  def edit
    @title = "Edit user"
    # user allready fetched in before filter
    #@user = User.find(params[:id])
  end

  def update
    #@user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "Profile updated."
      redirect_to @user
    else
      @title = "Edit user"
      render 'edit'
    end
  end

  def destroy    
    user = User.find(params[:id])
    if user == current_user
      redirect_to users_path, :error => 'It is forbidden to delete yourself'
    else
      User.find(params[:id]).destroy
      flash[:success] = "User destroyed."
      redirect_to users_path
    end
  end



  private

  def authenticate
    deny_access unless signed_in?
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end

  def signed_in_user
    redirect_to(root_path) if signed_in?
  end


end
