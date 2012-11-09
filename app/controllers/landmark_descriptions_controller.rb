class LandmarkDescriptionsController < ApplicationController
  # GET /landmark_descriptions
  # GET /landmark_descriptions.json
  def index
    @landmark_descriptions = LandmarkDescription.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @landmark_descriptions }
    end
  end

  # GET /landmark_descriptions/1
  # GET /landmark_descriptions/1.json
  def show
    @landmark_description = LandmarkDescription.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @landmark_description }
    end
  end

  # GET /landmark_descriptions/new
  # GET /landmark_descriptions/new.json
  def new
    @landmark_description = LandmarkDescription.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @landmark_description }
    end
  end

  # GET /landmark_descriptions/1/edit
  def edit
    @landmark_description = LandmarkDescription.find(params[:id])
  end

  # POST /landmark_descriptions
  # POST /landmark_descriptions.json
  def create
    @landmark_description = LandmarkDescription.new(params[:landmark_description])

    respond_to do |format|
      if @landmark_description.save
        format.html { redirect_to @landmark_description, notice: 'Landmark description was successfully created.' }
        format.json { render json: @landmark_description, status: :created, location: @landmark_description }
      else
        format.html { render action: "new" }
        format.json { render json: @landmark_description.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /landmark_descriptions/1
  # PUT /landmark_descriptions/1.json
  def update
    @landmark_description = LandmarkDescription.find(params[:id])

    respond_to do |format|
      if @landmark_description.update_attributes(params[:landmark_description])
        format.html { redirect_to @landmark_description, notice: 'Landmark description was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @landmark_description.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /landmark_descriptions/1
  # DELETE /landmark_descriptions/1.json
  def destroy
    @landmark_description = LandmarkDescription.find(params[:id])
    @landmark_description.destroy

    respond_to do |format|
      format.html { redirect_to landmark_descriptions_url }
      format.json { head :no_content }
    end
  end
end
