Spree::Admin::UsersController.class_eval do

      def orders
        params[:q] ||= {}
        @search = Spree::Order.reverse_chronological.ransack(params[:q].merge(user_id_eq: @user.id))
        @orders = @search.result.page(params[:page]).per(Spree::Config[:admin_products_per_page] || Spree::Config[:admin_greetings_per_page])
      end

      def items
        params[:q] ||= {}
        @search = Spree::Order.includes(
          line_items: {
            variant: [:product, :greeting, { option_values: :option_type }]
          }).ransack(params[:q].merge(user_id_eq: @user.id))
        @orders = @search.result.page(params[:page]).per(Spree::Config[:admin_products_per_page] || Spree::Config[:admin_greetings_per_page])
      end

      protected

        def collection
          return @collection if @collection.present?
          @collection = super
          if request.xhr? && params[:q].present?
            @collection = @collection.includes(:bill_address, :ship_address)
                              .where("spree_users.email #{LIKE} :search
                                     OR (spree_addresses.firstname #{LIKE} :search AND spree_addresses.id = spree_users.bill_address_id)
                                     OR (spree_addresses.lastname  #{LIKE} :search AND spree_addresses.id = spree_users.bill_address_id)
                                     OR (spree_addresses.firstname #{LIKE} :search AND spree_addresses.id = spree_users.ship_address_id)
                                     OR (spree_addresses.lastname  #{LIKE} :search AND spree_addresses.id = spree_users.ship_address_id)",
                                    { search: "#{params[:q].strip}%" })
                              .limit(params[:limit] || 100)
          else
            @search = @collection.ransack(params[:q])
            @collection = @search.result.page(params[:page]).per(Spree::Config[:admin_products_per_page] || Spree::Config[:admin_greetings_per_page])
          end
        end
      
end
