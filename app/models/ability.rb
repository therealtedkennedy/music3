class Ability
  include CanCan::Ability

  def initialize(user)

    if user

      can :update, Artist, :users => {:id => user.id}
      can :delete, Artist, :users => {:id => user.id}
      can :admin, Artist, :users => {:id => user.id}
      can :create, Artist
      #can :manage, :all
      can :read, :all

    else

      can :read, :all
    end
  end

end
