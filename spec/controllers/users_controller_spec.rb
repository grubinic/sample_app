require 'spec_helper'

describe UsersController do
  render_views

  describe "GET 'new'" do
    it "should be successful" do
      get 'new'
      response.should be_success
    end

    #webrat probably uses regexps
    it "should have the right title" do
      get 'new'
      response.should have_selector("title",
        :content => "Sign up")
    end

  end

  describe "GET 'show'" do

    before(:each) do
      @user = Factory(:user)
    end

    it "should be successful" do
      # get 'show' and get :show both work -> symbols preffered
      # :id => @user.id also works, but :id => @user is more idiomatic
      get :show, :id => @user
      response.should be_success
    end

    it "should find the right user" do
      get :show, :id => @user
      # from Test::Unit lib, assings(:user) returns instance
      # variable @user in the controller action

      # the controller WILL hit the database -> alternative, use stubs:
      # User.stub!(:find, @user.id).and_return(@user), rspec will intercept the
      # find method call and return the user
      assigns(:user).should == @user
    end

    it "should have the right title" do
      get :show, :id => @user
      response.should have_selector("title", :content => @user.name)
    end

    it "should include the user's name" do
      get :show, :id => @user
      response.should have_selector("h1", :content => @user.name)
    end

    it "should have a profile image" do
      get :show, :id => @user
      # test if image exists inside h1, of css class gravatar
      response.should have_selector("h1>img", :class => "gravatar")
    end

  end


end
