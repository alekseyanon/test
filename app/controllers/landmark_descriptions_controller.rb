class LandmarkDescriptionsController < ApplicationController
  before_filter :get_categories, only: [:new, :edit, :create, :update, :search]
  before_filter :get_landmark, only: [:edit, :show]
  before_filter :authenticate_user!, only: [:new, :edit, :create, :update]

  respond_to :html, :json

  def sanitize_search_params(params)
    params && params.symbolize_keys.slice(:text, :x, :y, :r, :facets, :sort_by) #TODO consider using ActiveRecord for this
  end

  def history
    @landmark_description = LandmarkDescription.find(params[:id])
  end

  def index
    landmark_descriptions = LandmarkDescription.search sanitize_search_params(params.symbolize_keys[:query])
    @landmark_descriptions = Kaminari.paginate_array(landmark_descriptions).page(params[:page]).per(25)
    respond_with @landmark_descriptions
  end

  def search
  end

  def do_search
    redirect_to landmark_descriptions_path query:sanitize_search_params(params)
  end

  #only json
  def coordinates
    @points = Osm::Node.with_landmarks.limit(10).pluck(:geom).map{|p| [p.y, p.x]}
    respond_with @points
  end

  #only json
  def nearest_node
    node = Osm::Node.closest_node(params["x"], params["y"]).first
    respond_with node.latlon
  end

  def show
    @categories_tree = @landmark_description.categories_tree
    @tags = @landmark_description.leaf_categories
    respond_with @landmark_description
  end

  def new
    @landmark_description = LandmarkDescription.new
    respond_with @landmark_description
  end

  def edit
  end

  def create
    x = params[:landmark_description][:xld] || 30.255188941955566
    y = params[:landmark_description][:yld] || 59.94736006104373

    #TODO cleanup
    @landmark_description = LandmarkDescription.new params[:landmark_description]
    @landmark_description.user = current_user
    ### TODO: Make decision. Maybe Landmark is useless. Maybe we can use Osm:Node only
    node = Osm::Node.closest_node(x,y).first
    nl = node.geo_unit ? node.geo_unit : (Landmark.create osm: Osm::Node.closest_node(x,y).first)
    @landmark_description.describable = nl
    @landmark_description.geom = node.geom
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

  def update

    x = params[:landmark_description][:xld]
    y = params[:landmark_description][:yld]

    @landmark_description = LandmarkDescription.find(params[:id])
    unless x.blank? && y.blank?
      lm = @landmark_description.describable
      lm.osm = Osm::Node.closest_node(x,y).first
      lm.save
    end

    respond_to do |format|
      if @landmark_description.update_attributes params[:landmark_description]
        format.html { redirect_to @landmark_description, notice: 'Landmark description was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @landmark_description.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @landmark_description = LandmarkDescription.find(params[:id])
    @landmark_description.destroy
    respond_to do |format|
      format.html { redirect_to landmark_descriptions_url }
      format.json { head :no_content }
    end
  end

  def count
    respond_to { |format| format.json { render json: LandmarkDescription.count } }
  end

  protected

  def get_categories
    @categories = Category.select [:name, :name_ru] #TODO move to model?
  end

  def get_landmark
    @landmark_description = LandmarkDescription.find(params[:id])
    @y, @x = @landmark_description.describable.osm.latlon
  end
end
