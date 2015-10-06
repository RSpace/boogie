class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable, :authentication_keys => [:username]

  has_many :bookings

  validates_presence_of :username

  def email_required?
    false
  end

  def admin?
    # TODO: Allow for multiple admin users
    self.username == 'admin'
  end
end
