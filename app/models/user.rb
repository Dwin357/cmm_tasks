class User < ActiveRecord::Base
  has_many :tasks

  validates :username, presence: true, uniqueness: true

  include BCrypt

  def password
    @password ||= Password.new(password_digest)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_digest = @password
  end

  def authentic_password?(_password)
    password == _password
  end

  def reset_password_to_random
    random_password = Array.new(10).map{ (65+ rand(58)).chr }.join
    self.password = random_password
    self.save!
    random_password
  end
end
