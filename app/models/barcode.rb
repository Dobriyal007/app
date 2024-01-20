class Barcode < ApplicationRecord
	belongs_to :fa
	
	validates :barcode, presence: true, length: { maximum: 40 }
end
