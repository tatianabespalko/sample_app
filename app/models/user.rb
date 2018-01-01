class User < ActiveRecord::Base

	has_secure_password
	before_save { self.email = email.downcase }
  before_create :create_remember_token
	validates :name, presence: true, length: { maximum: 50 } #Валидация наличия name атрибута. 
	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
	validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
					  uniqueness: {case_sensitive: false }
					  # true => case_sensitive: false
	validates :password, length: { minimum: 6 }
  has_many :microposts, dependent: :destroy

  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def feed
    # Это предварительное решение. См. полную реализацию в "Following users".
    Micropost.where("user_id = ?", id)
  end

  private

    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
    end
end
