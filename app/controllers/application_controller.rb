class ApplicationController < ActionController::Base
  protect_from_forgery
  #available in all views and CONTROLLERS (?)
  include SessionsHelper
end
