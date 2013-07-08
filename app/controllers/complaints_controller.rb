class ComplaintsController < InheritedResources::Base
  before_filter :authenticate_user!, only: [:new, :create, :index]
  load_and_authorize_resource only: CRUD_ACTIONS

  def new
    @complaintable = find_complaintable
    @complaintable.insert(-1, Complaint.new)
    respond_to do |format|
      format.html{ render layout: false}
    end
  end

  def create
    @complaintable = find_complaintable
    @complaint = @complaintable.last.complaints.build(params[:complaint])
    @complaint.user = current_user
    if @complaint.save
      redirect_to @complaintable.first
    else
      render action: 'new'
    end
  end

  private

    def find_complaintable
      complaintable = []
      params.each do |name, value|
        if name =~ /(.+)_id$/
          complaintable << $1.classify.constantize.find(value)
        end
      end
      complaintable.blank? ? nil : complaintable
    end
end
