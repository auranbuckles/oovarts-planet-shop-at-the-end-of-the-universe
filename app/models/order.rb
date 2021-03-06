class Order < ActiveRecord::Base
	belongs_to :planet
	belongs_to :feature

	validates :size, presence: true, numericality: { less_than_or_equal_to: 8000000 }

	def feature_attributes=(attributes)
		feature = Feature.find_or_create_by(attributes)
		self.feature_id = feature.id
	end

end
