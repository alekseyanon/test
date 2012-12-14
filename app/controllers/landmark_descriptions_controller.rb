class LandmarkDescriptionsController < ApplicationController
  before_filter :get_categories, :only => [:new, :edit, :create, :update, :search]

  def sanitize_search_params(params)
    params && params.symbolize_keys.slice(:text, :x, :y, :r) #TODO consider using ActiveRecord for this
  end

  def history
    @landmark_description = LandmarkDescription.find(params[:id])
  end

  # GET /landmark_descriptions
  # GET /landmark_descriptions.json
  def index
    @landmark_descriptions = LandmarkDescription.search sanitize_search_params(params.symbolize_keys[:query])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @landmark_descriptions.to_json(
          only: [:id, :title, :body],
          methods: :tag_list,
          include: {
              describable: {
                  only: [],
                  include: {
                      osm: {
                         only: [],
                         methods: :latlon }}}} ) }
    end
  end

  def search
  end

  def do_search
    redirect_to landmark_descriptions_path query:sanitize_search_params(params)
  end

  def coordinates
    @points = Osm::Node.with_landmarks.limit(10).pluck(:geom).map{|p| [p.y, p.x]}
    respond_to do |format|
      format.json { render :json => @points }
    end
  end

  def nearest_node
    node = Osm::Node.closest_node(params["x"], params["y"]).first
    respond_to do |format|
      format.json { render :json => node.latlon }
    end
  end

  # GET /landmark_descriptions/1
  # GET /landmark_descriptions/1.json
  def show
    @landmark_description = LandmarkDescription.find(params[:id])
    @y, @x = @landmark_description.describable.osm.latlon
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
    @y, @x = @landmark_description.describable.osm.latlon
  end

  # POST /landmark_descriptions
  # POST /landmark_descriptions.json
  def create
    x = params[:landmark_description][:xld] || 30.255188941955566
    y = params[:landmark_description][:yld] || 59.94736006104373
    params[:landmark_description][:tag_list].delete("")
    @landmark_description = LandmarkDescription.new(params[:landmark_description])
    @landmark_description.user = current_user
    # Maybe Landmark is useless. Maybe we can use Osm:Node only
    nl = Landmark.new
    nl.osm = Osm::Node.closest_node(x,y).first
    nl.save
    @landmark_description.describable = nl
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
    #TODO use sanitize_search_params, update if required

    x = params[:landmark_description][:xld] 
    y = params[:landmark_description][:yld] 
    params[:landmark_description][:tag_list].delete("")
    @landmark_description = LandmarkDescription.find(params[:id])
    lm = @landmark_description.describable
    lm.osm = Osm::Node.closest_node(x,y).first
    lm.save
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

  protected

  def get_categories
    @categories = Category.select([:name, :name_ru]) #TODO move to model?
  end
end
