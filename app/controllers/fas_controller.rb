class FasController < ApplicationController

  def index
  	@fas = Fa.paginate(page: params[:page], per_page: 8)
  end

  def show
  	@fa = Fa.find(params[:id])
  end

  def new
  	@fa = Fa.new
  end

  def create
  	@fa = Fa.new(fa_params)
    if @fa.save
      redirect_to @fa, notice: 'Data was successfully saved.'
    else
      flash.now[:alert] = 'Data is not complete or correct.'
      render "new"
    end
  end

  # def export_excel
  # 	binding.pry
  #   respond_to do |format|
  #     format.xlsx {
  #     	@fa = Fa.find(params[:id]
  #     	@barcode = @fa.barcodes
  #       # @barcode =  Barcode.find_by("fa_id")
  #       render xlsx: 'export_excel', filename: "fas_data_#{Time.now.strftime('%Y%m%d%H%M%S')}.xlsx"
  #     }
  #   end
  # end

  def export_excel
	  binding.pry
	  respond_to do |format|
	    format.xlsx {
	      barcode = @fa.barcodes
	      xlsx_package = Axlsx::Package.new
	      wb = xlsx_package.workbook

	      wb.add_worksheet(name: 'Fas Data') do |sheet|
	        sheet.add_row ['Serial No.', 'Date', 'Time', 'Line', 'Model', 'Barcode']

	        barcode.each_with_index do |barcode, index|
	          sheet.add_row [
	            index + 1,
	            @fa.date&.strftime('%Y-%m-%d'),
	            @fa.time&.strftime('%H:%M:%S'),
	            barcode.fa.Line,
	            barcode.fa.Model,
	            barcode.value
	          ]
	        end
	      end

	      render xlsx: 'export_excel', filename: "fas_data_#{Time.now.strftime('%Y%m%d%H%M%S')}.xlsx"
	    }
	  end
	end


  def destroy
	  @fa = Fa.find(params[:id])
	  @fa.destroy
	  redirect_to @fa, notice: 'Data was successfully destroyed.'
	end

	# def submit_barcode_data
	# 	binding.pry
	#   @fa = Fa.find(params[:id])
	#   # Assuming the form sends barcode data in the params
	#   barcode_params = params[:barcodes]
	#   # barcode_values = params[:barcodes].map { |barcode| barcode[:value] }
	#   barcode_values.each do |value|
	# 	  @fa.barcodes.create(value: value)
	# 	end

	#   # Save barcode data to the database
	#   barcode_params.each do |barcode_data|
	#     @fa.barcodes.create(value: barcode_data[:value])
	#   end
	#   redirect_to barcodes_fa_path(@fa), notice: 'Barcode data submitted successfully.'
	# end

  def submit_barcode_data
	  @fa = Fa.find(params[:format])
	  
	  barcode_values = params[:fa][:barcodes].map { |barcode| barcode[:value] }
	  # Check if all barcode values are present
    all_values_present = barcode_values.all?(&:present?)
	  
	  if all_values_present
	    # Build Barcode objects associated with @fa
	    barcode_values.each do |value|
	      @fa.barcodes.build(value: value)
	    end

	    # Save the @fa instance and all associated Barcode objects to the database
	    if @fa.save
	      redirect_to barcodes_fa_path(@fa), notice: 'Barcode data submitted successfully.'
	    else
	      flash.now[:alert] = 'Failed to save barcode data.'
	      render 'show'
	    end
	  else
	    flash.now[:alert] = 'Please provide values for all barcodes.'
	    render 'show'
	  end
	end
  
 #  def submit_barcode_data
 #  	binding.pry
	#   @fa = Fa.find(params[:id])

	#   # Assuming the form sends barcode data in the params
	#   barcode_values = params[:fa][:barcodes].map { |barcode| barcode[:value] }

	#   # Save barcode data to the database
	  # barcode_values.each do |value|
	  #   @fa.barcodes.build(value: value)
	  # end
	#   redirect_to barcodes_fa_path(@fa), notice: 'Barcode data submitted successfully.'
	# end


	def barcodes
	  @fa = Fa.find(params[:id])
	  @barcodes = @fa.barcodes
	end


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