require "bcrypt"

module TestPasswordHelper
  def default_password_digest
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : 
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(default_password, cost: cost)
  end

  def default_password
    "password"
  end
end