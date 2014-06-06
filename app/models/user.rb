class User < ActiveRecord::Base
  has_secure_password
  before_save { self.email = email.downcase }
  before_create :create_remember_token
  validates :name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(?:\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :email, presence:   true,
                    format:     { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, length: { minimum: 6 }
  
  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end
  
  def User.digest(token)
    Digest::SHA1.hexdigest(token.to_s)
  end  
  
  #The digest and new_remember_token methods are attached to the User class because they don’t need a user instance to work
  
  private
  
    def create_remember_token
      self.remember_token = User.digest(User.new_remember_token)
      #without self the assignment would create a local variable called remember_token, 
      #which isn’t what we want at all. Using self ensures that assignment sets the user’s remember_token, 
      #and as a result it will be written to the database along with the other attributes when the user is saved.
    end  
  
  
end