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

  def export_excel
	  # Find the Fa object using params[:id]
	  @fa = Fa.find(params[:id])
	  respond_to do |format|
	    format.xlsx {
	      # Now that @fa is assigned, you can access its barcodes
	      @barcode = @fa.barcodes
	      # Proceed with building and rendering the Excel file
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
	    	flash[:notice] = 'Barcode data submitted successfully.'
	    	# render 'submitted_data'
	      redirect_to  submitted_data_fa_path(@fa), notice: 'Barcode data submitted successfully.'
	      # redirect_to barcodes_fa_path(@fa), notice: 'Barcode data submitted successfully.'
	    else
	      flash.now[:alert] = 'Failed to save barcode data.'
	      render 'show'
	    end
	  else
	    flash.now[:alert] = 'Please provide values for all barcodes.'
	    render 'show'
	  end
	end

	def barcodes
	  @fa = Fa.find(params[:id])
	  @barcodes = @fa.barcodes
	end

	def submitted_data
    @submitted_fas = Fa.includes(:barcodes).all
  end

  def search
    @barcode = Barcode.find_by(value: params[:barcode])
    if @barcode
      @fa = @barcode.fa
    else
      flash.now[:alert] = "Barcode not found."
    end
    render 'search'
  end


private

  def fa_params
    params.require(:fa).permit(:Line, :Model, :qty)
  end
end