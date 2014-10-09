class Ability
  include CanCan::Ability

  def initialize(user)

    if user.try(:email) == "therealtedkennedy@gmail.com"
      can :manage, :all
      can :destroy, :all

    elsif user

      # can [:update,:destroy,:admin,:artist_save_image,:destroy,:pre_delete], Artist do |artist|
      #       artist.try(:user) == user
      # end

     can [:update,:destroy,:show,:edit,:api_login,:sign_in_routing,:boo], User do |user_check|
        user_check.try(:id) == user.id
     end
      can :destroy, Artist, :users => {:id => user.id}
      can :update, Artist, :users => {:id => user.id}
      can :pre_delete, Artist, :users => {:id => user.id}
      can :admin, Artist, :users => {:id => user.id}
      can :artist_save_image, Artist, :users => {:id => user.id}
      can :field_update, Artist, :users => {:id => user.id}


      can :create, Artist
      #can :manage, :all
      can :read, :all

    else

      can :read, :all
    end
  end

end
