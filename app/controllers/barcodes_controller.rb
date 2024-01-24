# app/controllers/barcodes_controller.rb
class BarcodesController < ApplicationController

  def new
    @barcode = @fa.barcodes.new
  end

  def create
    @barcode = @fa.barcodes.build(barcode_params)

    if @barcode.save
      redirect_to barcodes_fa_path(@fa), notice: 'Barcode created successfully.'
    else
      flash.now[:alert] = 'Failed to save barcode data.'
      render :new
    end
  end

  private
  
  def barcode_params
    params.require(:barcode).permit(:value)
  end
end
