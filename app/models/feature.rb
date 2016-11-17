class Feature < ActiveRecord::Base
	before_save { self.name = name.downcase }

	has_many :orders
	has_many :planets, through: :orders

	validates :name, presence: true, uniqueness: true
	validates :description, presence: true, length: { maximum: 1000 }
end
