class FasController < ApplicationController
  # before_action :set_fa, only: [:show, :export_excel]
  # before_action :set_fa, only: [:show, :destroy]
  # before_action :set_fas, only: [:index]


  def index
  	@fas = Fa.paginate(page: params[:page], per_page: 10)
  end

  def show
  	if params[:id] == 'index'
      redirect_to action: 'index'
    else
      @fa = Fa.find(params[:id])
    end
  end


	# def show
	#   @fa = Fa.find(params[:id])

	#   respond_to do |format|
	#     format.turbo_stream { render turbo_stream: turbo_stream.replace(@fa) }
	#     format.html { render :show }
	#   end
	# end

  def new
  	@fa = Fa.new
  end

  def create
  	@fa = Fa.new(fa_params)
    if @fa.save
      redirect_to @fa, notice: 'Data was successfully saved.'
    else
      flash.now[:alert] = 'Data is not filled completely.'
      render "new"
    end
  end

   def export_excel
    respond_to do |format|
      format.xlsx {
        @fas = Fa.all
        render xlsx: 'export_excel', filename: "fas_data_#{Time.now.strftime('%Y%m%d%H%M%S')}.xlsx"
      }
    end
  end

  def destroy
	  @fa = Fa.find(params[:id])
	  @fa.destroy
	  redirect_to @fa, notice: 'Data was successfully destroyed.'
	end

	def submit_barcode_data
		binding.pry
	  @fa = Fa.find(params[:fa_id])
	  # Assuming the form sends barcode data in the params
	  barcode_params = params[:barcodes]

	  # Save barcode data to the database
	  barcode_params.each do |barcode_data|
	    @fa.barcodes.create(value: barcode_data[:value])
	  end
	  redirect_to barcodes_fa_path(@fa), notice: 'Barcode data submitted successfully.'
	end

	def barcodes
    @fa = Fa.find(params[:id])
    @barcodes = @fa.barcodes
  end


  # def submit_barcode_data
  #   # Assuming the form sends barcode data in the params
  #   barcode_params = params[:barcodes]
  #   # Save barcode data to the database
  #   barcode_params.each do |barcode_data|
  #     @fa.barcodes.create(
  #       value: barcode_data[:value],
  #     )
  #   end
  #   redirect_to barcodes_fa_path(@fa), notice: 'Barcode data submitted successfully.'
  # end

 #  def submit_barcode_data
 #  	binding.pry
	#   # Assuming the form sends barcode data in the params
	#   barcode_params = params[:barcodes]
	  
	#   # Log the parameters for debugging
	#   Rails.logger.debug "Barcode Params: #{barcode_params.inspect}"

	#   # Save barcode data to the database if present
	#   if barcode_params.present?
	#     barcode_params.each do |barcode_data|
	#       @fa.barcodes.create(value: barcode_data[:value])
	#     end
	#     redirect_to barcodes_fa_path(@fa), notice: 'Barcode data submitted successfully.'
	#   else
	#     redirect_to barcodes_fa_path(@fa), alert: 'No barcode data submitted.'
	#   end
	# end


private

  def set_fa
    @fa = Fa.find(params[:id])
  end

  def set_fas
    @fas = Fa.all
  end

  def fa_params
    params.require(:fa).permit(:Line, :Model, :qty)
  end

end