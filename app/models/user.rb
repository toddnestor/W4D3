class User < ActiveRecord::Base
  validates :user_name, :password_digest, presence: true
  validates :password, length: {minimum: 6, allow_nil: true}
  validates :user_name, uniqueness: true

  attr_reader :password

  after_initialize :ensure_session_token

  has_many :cats
  has_many :cat_rental_requests
  has_many :sessions

  def self.find_by_credentials(user_name, password)
    user = User.find_by_user_name(user_name)
    return user if user && user.is_password?(password)
    nil
  end

  def self.find_by_session_token(session_token)
    session = Session.find_by_session_token(session_token)
    return session.user if session
    nil
  end

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    bc_object = BCrypt::Password.new(self.password_digest)
    bc_object.is_password?(password)
  end

  def session_token
    token = SecureRandom::urlsafe_base64
    Session.create(user_id: self.id, session_token: token)
  end

  def ensure_session_token
    @session_token ||= session_token
  end
end
