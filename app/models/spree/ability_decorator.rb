class AbilityDecorator  
    include CanCan::Ability
    def initialize(user)
      user ||= Spree.user_class.new
      if user.respond_to?(:has_spree_role?) && user.has_spree_role?('admin')
        can :manage, :all
      else
		  can :display, Spree::Greeting
      end
    end
end

Spree::Ability.register_ability(AbilityDecorator)