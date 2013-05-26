node :complaint do |r|
  {
    url: new_complaint_polymorphic_path(r),
    current_user: r.complaints.exists?(user_id: current_user.id)
  }
end
