class Fa < ApplicationRecord
  # other attributes in your model
  has_many :barcodes, dependent: :destroy

  before_create :set_default_date_and_time

  validates :Line, presence: true
  validates :Model, presence: true
  validates :qty, presence: true, numericality: { only_integer: true }
  validate :validate_qty_limit

  LINES = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10',
   '11', '12', '13', '15', '16', '17', '18', '19', '20',
   '21', '22', '23', '24', '25', '26', '27', '28', '29', '30',
    '32'].freeze

  MODELS = ['SSE-SJB4', 'SSE-SAW5', 'SSE-SCG6', 'SSE-SCT9', 'SSE-SDF8', 'SSE-SCV2', 'SSE-SDS5', 'SSE-SFW9',
    'SSE-SGM1', 'SSE-SJJ6', 'SSE-SJJ8', 'SSE-SKG5', 'SSE-SLB2', 'SSE-SLB7', 'SSE-SKP7', 'SSE-SKP2',
    'SSE-JJ7', 'SSE-SJA4', 'SSE-SJZ3', 'SSE-SKK6', 'SSE-SJJ6', 'SSE-SKG5', 'MIX-SGK6',
    'MIX-SJZ5', 'MIX-SHR5', 'MIX-SKS1', 'BBK-SJV5', 'BBK-SKC1', 'BBK-SJQ5', 'BBK-SJQ6', 'BBK-SJV6',
    'BBK-SHX4', 'BBK-SHV2', 'BBK-SHD2', 'BBK-SFC8', 'BBK-SLF7', 'OPO-SCP5', 'OPO-SCR2', 'OPO-SDY7', 'OPO-SACJ1',
    'OPO-SGL3', 'OPO-SHC9', 'OPO-SHX3', 'OPO-SHN6', 'OPO-SHS8', 'OPO-SHV3', 'OPO-SKM1', 'OPO-SKY1',
    'OPO-SJB4', 'OPO-SEC3', 'OPO-SHC9', 'OPO-SDY5', 'OPO-SKY1', 'TSNSBC4', 'TSNSJY4', 'TSN-SKA6',
    'MTO-SDJ4', 'MTO-SCR6', 'MTO-SDR3', 'MTO-SBW3', 'MTO-SHV1', 'MTO-JU8', 'MTO-SJB1'].freeze

  private

  def set_default_date_and_time
    self.date = created_at.strftime('%Y-%m-%d')
    self.time ||= created_at.in_time_zone('Asia/Kolkata').strftime('%H:%M:%S')
  end

  def validate_qty_limit
    if qty.present? && qty.to_i > 25
      errors.add(:qty, "cannot exceed 25 parts")
    end
  end
end

