class Barcode < ApplicationRecord
	belongs_to :fa
	
	validates :value, presence: true, length: { maximum: 40 }, uniqueness: { scope: :fa_id, message: "must be unique for each FA" }
end
