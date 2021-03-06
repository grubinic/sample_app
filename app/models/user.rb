# == Schema Information
# Schema version: 20110122230431
#
# Table name: users
#
#  id                 :integer         not null, primary key
#  name               :string(255)
#  email              :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#  encrypted_password :string(255)
#  salt               :string(255)
#  admin              :boolean
#

class User < ActiveRecord::Base
 
  # trick -  VIRTUAL atribute password (not in db)
  attr_accessor :password

  #admin is not accessible!!! -> security
  attr_accessible :name, :email, :password, :password_confirmation

  email_regex = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

  validates :name, :presence => true,
    :length   => { :maximum => 50 }
  
  validates :email, :presence   => true,
    :format     => { :with => email_regex },
    #NOT AT DATABASE LEVEL!!
  :uniqueness => { :case_sensitive => false }

  # trick ->  also creates virtual attribute password_confirmation,
  # while confirming that it matches the password attribute at the same time.
  validates :password, :presence     => true,
    :confirmation => true,
    :length       => { :within => 6..40 }


  validates :name, :presence => true,
    :length   => { :maximum => 50 }

  # callback
  before_save :encrypt_password

  # Return true if the user's password matches the submitted password.
  def has_password?(submitted_password)    
    # Compare encrypted_password with the encrypted version of
    # submitted_password.
    encrypted_password == encrypt(submitted_password)
    
  end

  #class method!
  def self.authenticate(email, submitted_password)
    #User.find_by_email - User class can be omitted
    user = find_by_email(email)
    return nil  if user.nil?
    return user if user.has_password?(submitted_password)
  end

  def self.authenticate_with_salt(id, cookie_salt)
    user = find_by_id(id)
    (user && user.salt == cookie_salt) ? user : nil
  end


  private

  def encrypt_password
    # self required - otherwise it would be a local variable
    # can't use @encrypted_password, because .. they are not really atrributes
    # but methods ?
    self.salt = make_salt(password) if new_record?
    self.encrypted_password = encrypt(password)
  end
  
  def encrypt(string)   
    secure_hash("#{salt}--#{string}")
  end

  def make_salt(password)
    #salt is unique for each user - protect from rainbow attacks
    secure_hash("#{Time.now.utc}--#{password}")
  end

  def secure_hash(string)
    Digest::SHA2.hexdigest(string)
  end
  
end
