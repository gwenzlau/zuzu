class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         #temorarily remove... :recoverable, 
         :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :signature
  # attr_accessible :title, :body

  has_many :posts

  def as_json(options = nil)
    {
      :email => self.email,

      :password => self.password,
      :signature => self.signature,
    }
  end
end
