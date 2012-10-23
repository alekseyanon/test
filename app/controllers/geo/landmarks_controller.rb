class Geo::LandmarksController < ApplicationController
  before_filter :get_categories, :get_nodes, :only => [:new, :edit, :create, :update]

  # GET /geo/landmarks
  # GET /geo/landmarks.json
  def index
    @geo_landmarks = Geo::Landmark.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @geo_landmarks }
    end
  end

  # GET /geo/landmarks/1
  # GET /geo/landmarks/1.json
  def show
    @geo_landmark = Geo::Landmark.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @geo_landmark }
    end
  end

  # GET /geo/landmarks/new
  # GET /geo/landmarks/new.json
  def new
    @geo_landmark = Geo::Landmark.new
    #require 'pp'
    #pp @categories
    #pp @nod
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @geo_landmark }
    end
  end

  # GET /geo/landmarks/1/edit
  def edit
    @categories = Category.select(:name).map(&:name)
    #@node_ids = Geo::Osm::Node.select(:id).map(&:id)
    @geo_landmark = Geo::Landmark.find(params[:id])
  end

  # POST /geo/landmarks
  # POST /geo/landmarks.json
  def create
    @geo_landmark = Geo::Landmark.new(params[:geo_landmark])

    respond_to do |format|
      if @geo_landmark.save
        format.html { redirect_to @geo_landmark, notice: 'Landmark was successfully created.' }
        format.json { render json: @geo_landmark, status: :created, location: @geo_landmark }
      else
        format.html { render action: "new" }
        format.json { render json: @geo_landmark.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /geo/landmarks/1
  # PUT /geo/landmarks/1.json
  def update
    @geo_landmark = Geo::Landmark.find(params[:id])

    respond_to do |format|
      if @geo_landmark.update_attributes(params[:geo_landmark])
        format.html { redirect_to @geo_landmark, notice: 'Landmark was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @geo_landmark.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /geo/landmarks/1
  # DELETE /geo/landmarks/1.json
  def destroy
    @geo_landmark = Geo::Landmark.find(params[:id])
    @geo_landmark.destroy

    respond_to do |format|
      format.html { redirect_to geo_landmarks_url }
      format.json { head :no_content }
    end
  end

  protected

  def get_categories
    @categories = Category.select(:name).map(&:name) #TODO move to model?
  end

  def get_nodes
    @node_ids = Geo::Osm::Node.select(:id).limit(10).map(&:id) #TODO move to model?
  end
end
