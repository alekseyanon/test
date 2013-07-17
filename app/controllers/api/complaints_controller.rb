class Api::ComplaintsController < InheritedResources::Base
  before_filter :authenticate_user!, only: [:new, :create, :index]
  before_filter :find_complaintable, only: [:new, :create]
  load_and_authorize_resource only: CRUD_ACTIONS

  ### TODO: should be removed after implement API
  def new
    @complaintable.insert(-1, Complaint.new)
  end

  ### TODO: should be changed after implement API
  def create
    @complaint = @complaintable.last.complaints.build(params[:complaint])
    @complaint.user = current_user
    @complaint.save
    render json: {success: :true}
  end

  private

    def find_complaintable
      complaintable = []
      params.each do |name, value|
        if name =~ /(.+)_id$/
          complaintable << $1.classify.constantize.find(value)
        end
      end
      @complaintable = complaintable.blank? ? nil : complaintable
    end
end
