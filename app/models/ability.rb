class Ability
  include CanCan::Ability

  def initialize(user)

    if user.try(:email) == "therealtedkennedy@gmail.com"
      can :manage, :all
      can :destroy, :all

    elsif user

      can [:update,:destroy,:admin,:create,:artist_save_image], Artist, :users => {:id => user.id}
      can [:update,:destroy,:show,:edit, :api_login,:sign_in_routing,:boo], User, :users => {:id => user.id}
      #can :delete, Artist, :users => {:id => user.id}
      can :admin, Artist, :users => {:id => user.id}
      can :create, Artist
      #can :manage, :all
      can :read, :all

    else

      can :read, :all
    end
  end

end
