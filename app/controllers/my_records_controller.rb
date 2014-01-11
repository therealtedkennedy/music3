class MyRecordsController < ApplicationController
  # GET /my_records
  # GET /my_records.json
  def index
    @my_records = MyRecord.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @my_records }
    end
  end

  # GET /my_records/1
  # GET /my_records/1.json
  def show
    @my_record = MyRecord.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @my_record }
    end
  end

  # GET /my_records/new
  # GET /my_records/new.json
  def new
    @my_record = MyRecord.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @my_record }
    end
  end

  # GET /my_records/1/edit
  def edit
    @my_record = MyRecord.find(params[:id])
  end

  # POST /my_records
  # POST /my_records.json
  def create
    @my_record = MyRecord.new(params[:my_record])

    respond_to do |format|
      if @my_record.save
        format.html { redirect_to @my_record, notice: 'My record was successfully created.' }
        format.json { render json: @my_record, status: :created, location: @my_record }
      else
        format.html { render action: "new" }
        format.json { render json: @my_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /my_records/1
  # PUT /my_records/1.json
  def update
    @my_record = MyRecord.find(params[:id])

    respond_to do |format|
      if @my_record.update_attributes(params[:my_record])
        format.html { redirect_to @my_record, notice: 'My record was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @my_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /my_records/1
  # DELETE /my_records/1.json
  def destroy
    @my_record = MyRecord.find(params[:id])
    @my_record.destroy

    respond_to do |format|
      format.html { redirect_to my_records_url }
      format.json { head :no_content }
    end
  end
end
