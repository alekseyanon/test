class GeoObjectsController < ApplicationController
  before_filter :get_categories, only: [:new, :edit, :create, :update, :search]
  before_filter :get_landmark, only: [:edit, :show]
  before_filter :authenticate_user!, only: [:new, :edit, :create, :update]

  respond_to :html, :json

  def sanitize_search_params(params)
    params && params.symbolize_keys.slice(:text, :x, :y, :r, :facets, :sort_by) #TODO consider using ActiveRecord for this
  end

  def history
    @geo_object = GeoObject.find(params[:id])
  end

  def index
    geo_objects = GeoObject.search sanitize_search_params(params.symbolize_keys[:query])
    @geo_objects = Kaminari.paginate_array(geo_objects).page(params[:page]).per(25)
    respond_with @geo_objects
  end

  def search
  end

  def do_search
    redirect_to geo_objects_path query:sanitize_search_params(params)
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
    @categories_tree = @geo_object.categories_tree
    @tags = @geo_object.leaf_categories
    respond_with @geo_object
  end

  def new
    @geo_object = GeoObject.new
    respond_with @geo_object
  end

  def edit
  end

  def create
    x = params[:geo_object][:xld] || 30.255188941955566
    y = params[:geo_object][:yld] || 59.94736006104373

    #TODO cleanup
    @geo_object = GeoObject.new params[:geo_object]
    @geo_object.user = current_user
    ### TODO: Make decision. Maybe Landmark is useless. Maybe we can use Osm:Node only
    node = Osm::Node.closest_node(x,y).first
    nl = node.geo_unit ? node.geo_unit : (Landmark.create osm: Osm::Node.closest_node(x,y).first)
    @geo_object.describable = nl
    @geo_object.geom = node.geom
    respond_to do |format|
      if @geo_object.save
        format.html { redirect_to @geo_object, notice: 'Landmark description was successfully created.' }
        format.json { render json: @geo_object, status: :created, location: @geo_object }
      else
        format.html { render action: "new" }
        format.json { render json: @geo_object.errors, status: :unprocessable_entity }
      end
    end
  end

  def update

    x = params[:geo_object][:xld]
    y = params[:geo_object][:yld]

    @geo_object = GeoObject.find(params[:id])
    unless x.blank? && y.blank?
      lm = @geo_object.describable
      lm.osm = Osm::Node.closest_node(x,y).first
      lm.save
    end

    respond_to do |format|
      if @geo_object.update_attributes params[:geo_object]
        format.html { redirect_to @geo_object, notice: 'Landmark description was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @geo_object.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @geo_object = GeoObject.find(params[:id])
    @geo_object.destroy
    respond_to do |format|
      format.html { redirect_to geo_objects_url }
      format.json { head :no_content }
    end
  end

  def count
    respond_to { |format| format.json { render json: GeoObject.count } }
  end

  protected

  def get_categories
    @categories = Category.select [:name, :name_ru] #TODO move to model?
  end

  def get_landmark
    @geo_object = GeoObject.find(params[:id])
    @y, @x = @geo_object.describable.osm.latlon
  end
end
