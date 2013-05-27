node :complaint do |r|
  {
    url: new_complaint_polymorphic_path(r),
    current_user: current_user.nil? ? 0 : r.complaints.exists?(user_id: current_user.id)
  }
end
