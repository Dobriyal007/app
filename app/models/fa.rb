class Fa < ApplicationRecord
  # other attributes in your model
  has_many :barcodes, dependent: :destroy

  before_create :set_default_date_and_time

  validates :Line, presence: true
  validates :Model, presence: true
  validates :qty, presence: true, numericality: { only_integer: true }, length: { maximum: 10 }
  # validates :barcode, presence: true, length: { maximum: 40 }

  LINES = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10',
   '11', '12', '13', '15', '16', '17', '18', '19', '20',
   '21', '22', '23', '24', '25', '26', '27', '28', '29', '30',
    '31'].freeze
  MODELS = ['SC9', 'DY5', 'SSESLB2', 'SSESLB7', 'SSESKP7',
  	'SSEJJ7', 'SSESJA4', 'SSESJZ3', 'SSESKK6', 'SSESJJ6', 'MIXSGK6', 'MIXSJZ5', 'MIXSJZ5', 'MIXSHR5',
  	'MIXSKS1', 'BBKSDH6', 'BBKSGA5', 'HD2', 'BBKSFC8', 'BBKSGM3', 'BBKSHX4', 'BBKSHV2',
  	'BBKSJV5', 'BBKSKC1', 'BBKSJQ5', 'BBKSJQ6', 'BBKSJV6', 'OPOSACJ1', 'OPOSCP5',
  	'OPOSCR2', 'DY7', 'OPOSGL3', 'OPOSHC9', 'OPOSHX3', 'OPOSHN6', 'OPOSHS8', 'OPOSHV3',
  	'Q6', 'OPOSJB4', 'OPOSEC3', 'SSESAW5', 'SSESCG6', 'SSESCT9', 'SSESDF8', 'SSESCV2',
  	'SSESDS5', 'SSESFW9', 'SSESGM1', 'SSESJJ6', 'SSESJJ8', 'SSESKG5', 'TSNSBC4', 'TSNSJY4',
  	'TSNSKA6', 'MTOSDJ4', 'MTOSCR6', 'MTOSDR3', 'MTOSBW3', 'MTOSHV1', 'JU8', 'MTOSJB1'].freeze

  private

  def set_default_date_and_time
    self.date = created_at.strftime('%Y-%m-%d')
    self.time ||= created_at.in_time_zone('Asia/Kolkata').strftime('%H:%M:%S')
  end
end

