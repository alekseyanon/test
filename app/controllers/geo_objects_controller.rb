class GeoObjectsController < ApplicationController
  before_filter :get_categories, only: [:new, :edit, :create, :update, :search]
  before_filter :get_landmark, only: [:edit, :show]
  before_filter :authenticate_user!, only: [:new, :edit, :create, :update]

  respond_to :json
  respond_to :html, except: [:coordinates, :nearest_node, :count]

  def sanitize_search_params(params)
    params && params.symbolize_keys.slice(:text, :x, :y, :r, :facets, :sort_by) #TODO consider using ActiveRecord for this
  end

  def history
    @geo_object = GeoObject.find(params[:id])
  end

  def index
    geo_objects = GeoObject.search sanitize_search_params(params.symbolize_keys[:query])
    @geo_objects = Kaminari.paginate_array(geo_objects).page(params[:page]).per(25)
    if (params[:page].nil? || params[:page] == 1) && (params[:query].blank? || params[:query][:facets].blank?)
      @geo_objects = mark_best_geo_object @geo_objects
    end
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
    #REVIEW create from coord
    @geo_object.geom = Osm::Node.closest_node(x,y).first.geom unless x.blank? && y.blank?


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

  def images
    @geo_object = GeoObject.find(params[:id])
  end

  def count
    respond_with GeoObject.count
  end

  protected

  def get_categories
    @categories = Category.select [:name, :name_ru] #TODO move to model?
  end

  def get_landmark
    @geo_object = GeoObject.find(params[:id])
    @y, @x = @geo_object.latlon
  end

  private

  # вычисляет "лучшие" объекты
  def mark_best_geo_object geo_objects
    data = {} # тут сохраняю лучший рейтинг и индекс объекта в категории
    geo_objects.each_with_index do |o,i|
      o.tags.each do |t|
        c = Category.find_by_name t.name # Ууупс TODO REVIEW kill acts_as_taggable_on помоему он на фиг не нужен
        if c.level == 2 && (data[t.name].nil? || data[t.name][:rating] < o.rating)
          data[t.name] = {} unless data[t.name].kind_of? Hash
          data[t.name][:rating] = o.rating
          geo_objects[data[t.name][:i]].best_object = false if data[t.name][:i].kind_of? Integer
          o.best_object = true
          data[t.name][:i] = i
        end
      end
    end
    geo_objects
  end

end
