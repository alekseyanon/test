class Api::GeoObjectsController < ApplicationController
  def sanitize_search_params(params) #TODO remove duplication in geo_objects_controller.rb
    params && params.symbolize_keys.
        slice(:text, :x, :y, :r, :bounding_box, :facets, :sort_by, :agc_id).
        delete_if { |_, v| v.blank? } #TODO consider using ActiveRecord for this
  end

  def nearby
    r = params[:r] || 1000
    @objects = GeoObject.find(params[:id]).objects_nearby(r)
    render json: @objects
  end

  def show
    ld = GeoObject.find params[:id]
    render json: ld.to_json( extra: { teaser: params[:teaser] } )
  end

  def index
    query = sanitize_search_params(params.symbolize_keys[:query])
    query[:bounding_box] &&= query[:bounding_box].split(',').map(&:to_f)
    result = GeoObject.search(query)
    SearchQuery.add(query[:text], current_user) if result.size != 0
    render json: result
  end
end
