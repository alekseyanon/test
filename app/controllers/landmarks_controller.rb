class LandmarksController < ApplicationController
  before_filter :get_nodes, :only => [:new, :edit, :create, :update, :search]

  # GET /landmarks
  # GET /landmarks.json
  def index
    @landmarks = Landmark.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @landmarks }
    end
  end

  def search
    render "/landmarks/search/tags"
  end

  def do_search
    redirect_to landmarks_path tag_list:params[:tag_list]
  end

  # GET /landmarks/1
  # GET /landmarks/1.json
  def show
    @landmark = Landmark.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @landmark }
    end
  end

  # GET /landmarks/new
  # GET /landmarks/new.json
  def new
    @landmark = Landmark.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @landmark }
    end
  end

  # GET /landmarks/1/edit
  def edit
    @categories = Category.select(:name).map(&:name)
    #@node_ids = Osm::Node.select(:id).map(&:id)
    @landmark = Landmark.find(params[:id])
  end

  # POST /landmarks
  # POST /landmarks.json
  def create
    @landmark = Landmark.new(params[:landmark])

    respond_to do |format|
      if @landmark.save
        format.html { redirect_to @landmark, notice: 'Landmark was successfully created.' }
        format.json { render json: @landmark, status: :created, location: @landmark }
      else
        format.html { render action: "new" }
        format.json { render json: @landmark.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /landmarks/1
  # PUT /landmarks/1.json
  def update
    @landmark = Landmark.find(params[:id])

    respond_to do |format|
      if @landmark.update_attributes(params[:landmark])
        format.html { redirect_to @landmark, notice: 'Landmark was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @landmark.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /landmarks/1
  # DELETE /landmarks/1.json
  def destroy
    @landmark = Landmark.find(params[:id])
    @landmark.destroy

    respond_to do |format|
      format.html { redirect_to landmarks_url }
      format.json { head :no_content }
    end
  end

  protected

  def get_nodes
    @node_ids = Osm::Node.select(:id).limit(10).map(&:id) #TODO move to model?
  end
end
