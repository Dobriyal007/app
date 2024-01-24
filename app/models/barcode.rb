class Barcode < ApplicationRecord
	belongs_to :fa
	
	validates :value, presence: true, length: { maximum: 40 }
end
