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
          methods: :tag_list
      ) }
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

  # GET /landmark_descriptions/1
  # GET /landmark_descriptions/1.json
  def show
    @landmark_description = LandmarkDescription.find(params[:id])
    #TODO move logic to model
    @categories = Category.where(:name_ru => @landmark_description.tag_list )
    @branches = []
    @categories.each do |c|
    ## TODO add branch @branches << c.ancestors + 
      @branches << (c.ancestors << c)
    end
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @landmark_description }
    end
  end

  # GET /landmark_descriptions/new
  # GET /landmark_descriptions/new.json
  def new
    @landmark_description = LandmarkDescription.new
    #@landmark_description.describable.osm.geom.x
    #TODO use get_categories helper, already defined
    @categories = Category.all
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @landmark_description }
    end
  end

  # GET /landmark_descriptions/1/edit
  def edit
    @landmark_description = LandmarkDescription.find(params[:id])
    @categories = Category.all
  end

  # POST /landmark_descriptions
  # POST /landmark_descriptions.json
  def create
    #TODO cleanup
    # logger.debug "=============params================="
    # logger.debug params[:landmark_description]
    # logger.debug params[:landmark_description][:tag_list]
    params[:landmark_description][:tag_list].delete("")
    # logger.debug params[:landmark_description][:tag_list]
    @landmark_description = LandmarkDescription.new(params[:landmark_description])
    @landmark_description.user = current_user
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
    params[:landmark_description][:tag_list].delete("")
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

  protected

  def get_categories
    @categories = Category.select(:name).map(&:name) #TODO move to model?
  end
end
