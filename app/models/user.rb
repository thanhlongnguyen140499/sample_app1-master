class User < ApplicationRecord
    #before_save {self.email=email.downcase }
    attr_accessor :remember_token
    before_save { email.downcase! }
    validates:name,presence:true
    validates:email,presence:true
    validates:name,presence:true,length: {maximum:50}
    VALID_EMAIL_REGEX=  /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
    validates:email,presence:true,length: {maximum:255},    format: {with: VALID_EMAIL_REGEX},
            uniqueness:true
    has_secure_password
    #validates:password,presence:true,length: {minimum:6}
    validates:password,presence:true,length: {minimum:6}, allow_nil: true
    def remember
      #remember_token = new_token
      self.remember_token = User.new_token
     update_attribute(:remember_digest, User.digest(remember_token))
    end
    class << self
    # Returns the hash digest of the given string.
    #def self.digest(string)
    #def User.digest(string)
      def digest(string)
          cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                         BCrypt::Engine.cost
                         BCrypt::Password.create(string, cost: cost)
      end 
    # Returns a random token.
    def new_token
    #def self.new_token
    #def User.new_token 
      SecureRandom.urlsafe_base64
     end
    # Remembers a user in the database for use in persistent sessions.
    
    # Returns true if the given token matches the digest.
    
  end
  def authenticated?(remember_token) 
    return false if remember_digest.nil?
    BCrypt::Password.new(remember_digest).is_password?(remember_token)
  end
    # Forgets a user.
    def forget 
        update_attribute(:remember_digest, nil)
    end
end
