class Permission
  # Permission Model
  # Want to know how it works?
  # Watch RailsCasts #385 #386

  def initialize(user)
    allow :events, [:index, :show]
    if user
      allow :events, [:new, :create]
      allow :runtips, [:new, :create]
      allow :events, [:edit, :update] { |resource| resource.user_id == user.id }
      allow :runtips, [:edit, :update] { |resource| resource.user_id == user.id }
      allow_all if user.admin?
    end
  end

  def allow?(controller, action, resource = nil)
    allowed = @allow_all || @allowed_actions[[controller.to_s, action.to_s]]
    allowed && (allowed == true || resource && allowed.call(resource))
  end

  def allow_all
    @allow_all = true
  end

  def allow(controllers, actions, &block)
    @allowed_actions ||= {}
    Array(controllers).each do |controller|
      Array(actions).each do |action|
        @allowed_actions[[controller.to_s, action.to_s]] = block || true
      end
    end
  end
end
