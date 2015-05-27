class Book < ActiveRecord::Base
  has_many :book_copies
  has_many :holds
  belongs_to :subject
  dragonfly_accessor :qr_code

  after_create :generate_qr_code

  private
  def generate_qr_code
    qr_code_img = RQRCode::QRCode.new("id", :size => 4, :level => :h ).to_img
    self.qr_code = qr_code_img.to_string
    save
  end

end
