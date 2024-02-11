require 'axlsx'

class FasController < ApplicationController
	before_action :authenticate, only: :search

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

	def export_to_excel
	 	@submitted_fas = Fa.includes(:barcodes).all # Replace with your logic to retrieve data
    respond_to do |format|
      format.xlsx {
        # Create an Axlsx::Package and workbook
        xlsx_package = Axlsx::Package.new
        wb = xlsx_package.workbook

        # Define a centered and bordered style for the entire worksheet
        centered_bordered_style = wb.styles.add_style(
          alignment: { horizontal: :center },
          border: { style: :thin, color: '000000' } # Black border lines
        )

        # Define a bold style for the header
        bold_style = wb.styles.add_style(b: true, alignment: { horizontal: :center }, border: { style: :thin, color: '000000' })

         # Define a red style for the "NG" status
        red_style = wb.styles.add_style(
          b: true,
          alignment: { horizontal: :center },
          border: { style: :thin, color: '000000' },
          fg_color: 'FF0000' # Red background color
        )
         # Define a new style with an increased font size for the title row
  			title_style = wb.styles.add_style(b: true, sz: 14, alignment: { horizontal: :center },
  			 border: { style: :thin, color: '000000' })

        	
        # Add worksheet and headers
        wb.add_worksheet(name: 'Failure Analysis Data') do |sheet|
          # Add bold, centered, and bordered header row
          sheet.add_row ['Failure Analysis Data'], style: title_style
          sheet.merge_cells("A1:K1") # Merge cells for the title row
          sheet.add_row ['Sr No.', 'Date', 'Time', 'Line', 'Model', 'Barcode', 'Out Date', 'Out Time', 'FT Status', 'Remarks', 'Time Gap'], style: bold_style

          # Add data rows with the same style
          serial_number = 0
          @submitted_fas.reverse_each.with_index(1) do |fa, index|
            fa.barcodes.each do |barcode|
              serial_number += 1
              # Check if the status is "NG" and apply red_style
              status_style = (barcode.status == 'NG' ? red_style : centered_bordered_style)
              sheet.add_row [
                serial_number,
                fa.date&.strftime('%Y-%m-%d'),
                fa.time&.strftime('%H:%M:%S'),
                fa.Line,
                fa.Model,
                barcode.value,
                (barcode.status.present? ? barcode.updated_at&.strftime('%Y-%m-%d') : ''),
                (barcode.status.present? ? barcode.updated_at&.strftime('%H:%M:%S') : ''),
                barcode.status,
                barcode.remarks,
                (barcode.updated_at.present? && fa.time.present? && barcode.status.present? ? Time.at((barcode.updated_at.to_time - fa.time.to_time).abs).utc.strftime('%H:%M:%S') : '')
              ], style: status_style
            end
          end
        end

        # Send the file to the user
        send_data xlsx_package.to_stream.read, filename: "AF_data_#{Time.now.strftime('%Y%m%d%H%M%S')}.xlsx", type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet', disposition: 'attachment'
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
		password = params[:password]
	  @barcodes = Barcode.where(value: params[:barcode])
	  if @barcodes.present?
	  	# @search = @barcodes.first.fa
	    @search = @barcodes.map(&:fa)
	  else
	    flash.now[:alert] = "No matching barcodes found."
	    @search = []
	  end
	end

	def update_status_and_remarks
	  barcode = params[:barcode]
	  status = params[:status]
	  remarks = params[:remarks]

  	barcode_record = Barcode.find_by(value: barcode)
	  if barcode_record
	  	# Check if the status and remarks are present and not empty
	  	# barcode_record.update(status: status.presence || barcode_record.status, remarks: remarks.presence || barcode_record.remarks)
	    barcode_record.update(status: status, remarks: remarks)
	    updated_at_time = barcode_record.updated_at
	    flash.now[:alert] = 'Status and remarks updated successfully.'
	  else
	    flash.now[:alert] = 'Barcode not found.'
	    barcode_record = []
	  end
	  render 'search'
	end

	def graphs
		# @barcode_data = Fa.all.pluck([:Line])
		# @barcode_data = Barcode.group("strftime('%Y-%m-%d', created_at)").count
		@barcode_data = Barcode.group("strftime('%Y-%m-%d', created_at)").count
		@fa_data = Fa.includes(:barcodes).all.pluck("Model","Line")
		@line_chart_data = Fa.includes(:barcodes).group("DATE(barcodes.created_at)").group(:Line).sum(:qty)
		@model_chart_data = Fa.includes(:barcodes).group("DATE(barcodes.created_at)").group(:Model).sum(:qty)
	end

private

  def fa_params
    params.require(:fa).permit(:Line, :Model, :qty)
  end

  def authenticate
	  # Replace 'your_password' with your actual password
	  correct_password = '9023579'

	  # Check if the user is not already authenticated in the current session
	  unless session[:authenticated]
	    # If the current action is 'search', allow access without password check
	    return if params[:action] == 'search' && !params[:barcode].nil?

	    if params[:password] == correct_password
	      session[:authenticated] = true
	    else
	      flash[:alert] = 'Incorrect password. Access denied.'
	      redirect_to new_fa_path
	    end
	  else
	    # If the flag is already set (user is authenticated),
	    # reset the flag when the search button is clicked
	    session[:authenticated] = false
	  end
	end
end