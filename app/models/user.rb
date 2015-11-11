class User < ActiveRecord::Base
  has_and_belongs_to_many :games

  def role?(role_to_compare) 
      self.role.to_s == role_to_compare.to_s 
    end
end
