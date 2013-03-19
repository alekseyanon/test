class ComplaintsController < InheritedResources::Base
  before_filter :authenticate_user!, only: [:new, :create, :index]

  def new
    @complaintable = find_complaintable
    @complaint_models = @complaintable
    @complaint_models.insert(-1, Complaint.new)
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

  def index
    @complaintable = find_complaintable
    @complaints = @complaintable.last.complaints
  end

  private

    def find_complaintable
      flag = false
      complaintable = []
      params.each do |name, value|
        if name =~ /(.+)_id$/
          complaintable << $1.classify.constantize.find(value)
        end
      end
      complaintable.blank? ? nil : complaintable
    end
end
