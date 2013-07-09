class Ability
  include CanCan::Ability

  EDIT_LIMIT = 15.minutes

  def initialize(user)
    user ||= User.new

    case
      when user.admin?
        can :manage, :all
      when user.traveler?
        can [:create, :read], :all
        can [:update, :destroy], [Comment, Complaint, Event, Review] do |object|
          (object.user_id == user.id) && (object.updated_at >= Time.now - EDIT_LIMIT)
        end
        can :update, GeoObject
      else
        can :read, :all
    end
  end

end
