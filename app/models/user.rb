class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, omniauth_providers: [:facebook]

  has_many :planets

  def self.current
    Thread.current[:user]
  end

  def self.current=(user)
    Thread.current[:user] = user
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.first_name
    end      
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  def features_total
    array = []
    self.planets.each do |planet|
      planet.orders.each do |order|
        array << order.price * 1000
      end
    end
    array.inject(0){|sum,x| sum + x }
  end

  def planets_total
    self.planets.sum(:price) * 1000
  end

  def total_spent
    self.features_total + self.planets_total
  end

  def self.most_valued
    array = []
    all.each do |user|
      array << { user: user, total_spent: user.features_total + user.planets_total }
    end
    array.sort_by { |hash| hash[:total_spent] }.last
  end
end
