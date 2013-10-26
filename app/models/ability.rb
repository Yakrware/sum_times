class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user 
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. 
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
    
    can :manage, Workday, :user_id => user.id, :company => { :id => user.company_id }
    can :read, Workday, :company => { :id => user.company_id }
    
    can :manage, Leave, :user_id => user.id, :company => { :id => user.company_id }
    can :read, Leave, :user_id => user.id, :company => { :id => user.company_id }
    can :manage, Leave do |leave|
      leave.company.id == user.company_id && user.supervises.map(&:id).include?(leave.user_id)
    end
    
    can :read, User, :company_id => user.company_id
    can :read, Option, :user_id => user.id
  
    if user.admin?
      can :manage, Workday, :company => { :id => user.company_id }
      can :manage, Leave, :company => { :id => user.company_id }
      can :manage, User, :company_id => user.company_id
      can [:read, :update], Company, :id => user.company_id
      can :manage, Option, :company_id => user.company_id
      can :manage, Option, :user => { :company_id => user.company_id }
    end
    
  end
end
