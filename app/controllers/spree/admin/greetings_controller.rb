module Spree
  module Admin
    class GreetingsController < ResourceController
      helper 'spree/greetings'

      before_action :load_data, except: :index
      create.before :create_before
      #update.before :update_before
      helper_method :clone_object_url

      def show
        session[:return_to] ||= request.referer
        redirect_to action: :edit
      end

      def index
        session[:return_to] = request.url
        respond_with(@collection)
      end

      def update
        if params[:greeting][:taxon_ids].present?
          params[:greeting][:taxon_ids] = params[:greeting][:taxon_ids].split(',')
        end
        #if params[:greeting][:option_type_ids].present?
        #  params[:greeting][:option_type_ids] = params[:greeting][:option_type_ids].split(',')
        #end
        invoke_callbacks(:update, :before)
        if @object.update_attributes(permitted_resource_params)
          invoke_callbacks(:update, :after)
          flash[:success] = flash_message_for(@object, :successfully_updated)
          respond_with(@object) do |format|
            format.html { redirect_to location_after_save }
            format.js   { render layout: false }
          end
        else
          # Stops people submitting blank slugs, causing errors when they try to
          # update the greeting again
          @greeting.slug = @greeting.slug_was if @greeting.slug.blank?
          invoke_callbacks(:update, :fails)
          respond_with(@object)
        end
      end

      def destroy
        @greeting = Greeting.friendly.find(params[:id])

        begin
          # TODO: why is @greeting.destroy raising ActiveRecord::RecordNotDestroyed instead of failing with false result
          if @greeting.destroy
            flash[:success] = Spree.t('notice_messages.greeting_deleted')
          else
            flash[:error] = Spree.t('notice_messages.greeting_not_deleted')
          end
        rescue ActiveRecord::RecordNotDestroyed => e
          flash[:error] = Spree.t('notice_messages.greeting_not_deleted')
        end

        respond_with(@greeting) do |format|
          format.html { redirect_to collection_url }
          format.js  { render_js_for_destroy }
        end
      end

      def clone
        @new = @greeting.duplicate

        if @new.save
          flash[:success] = Spree.t('notice_messages.greeting_cloned')
        else
          flash[:error] = Spree.t('notice_messages.greeting_not_cloned')
        end

        redirect_to edit_admin_greeting_url(@new)
      end

      def stock
        @variants = @greeting.variants.includes(*variant_stock_includes)
        @variants = [@greeting.master] if @variants.empty?
        @stock_locations = StockLocation.accessible_by(current_ability, :read)
        if @stock_locations.empty?
          flash[:error] = Spree.t(:stock_management_requires_a_stock_location)
          redirect_to admin_stock_locations_path
        end
      end
      
      def varient
        
      end
      def greeting_preview
        @variants = @greeting.variants_including_master.
                             #spree_base_scopes.
                             active(current_currency)#.
                            # includes([:option_values, :images])
        #@greeting_properties = @greeting.greeting_properties.includes(:property)
        @taxon = params[:taxon_id].present? ? Spree::Taxon.find(params[:taxon_id]) : @greeting.taxons.first
        #redirect_if_legacy_path
      end
      
      protected

      def find_resource
        Greeting.with_deleted.friendly.find(params[:id])
      end

      def location_after_save
        spree.edit_admin_greeting_url(@greeting)
      end

      def load_data
        @taxons = Taxon.order(:name)
        #@option_types = OptionType.order(:name)
        @tax_categories = TaxCategory.order(:name)
        @shipping_categories = ShippingCategory.order(:name)
      end

      def collection
        return @collection if @collection.present?
        params[:q] ||= {}
        params[:q][:deleted_at_null] ||= "1"

        params[:q][:s] ||= "name asc"
        @collection = super
        # Don't delete params[:q][:deleted_at_null] here because it is used in view to check the
        # checkbox for 'q[deleted_at_null]'. This also messed with pagination when deleted_at_null is checked.
        if params[:q][:deleted_at_null] == '0'
          @collection = @collection.with_deleted
        end
        # @search needs to be defined as this is passed to search_form_for
        # Temporarily remove params[:q][:deleted_at_null] from params[:q] to ransack greetings.
        # This is to include all greetings and not just deleted greetings.
        @search = @collection.ransack(params[:q].reject { |k, _v| k.to_s == 'deleted_at_null' })
        @collection = @search.result.
              distinct_by_greeting_ids(params[:q][:s]).
              includes(greeting_includes).
              page(params[:page]).
              per(params[:per_page] || Spree::Config[:admin_greetings_per_page])
        @collection
      end

      def create_before
        return if params[:greeting][:prototype_id].blank?
        @prototype = Spree::Prototype.find(params[:greeting][:prototype_id])
      end

      #def update_before
        # note: we only reset the greeting properties if we're receiving a post
        #       from the form on that tab
      #  return unless params[:clear_greeting_properties]
      #  params[:greeting] ||= {}
      #end

      def greeting_includes
        #[{ variants: [:images], master: [:images, :default_price] }]
        [{ master: [:default_price] }]
      end

      def clone_object_url(resource)
        clone_admin_greeting_url resource
      end

      private

      def variant_stock_includes
       # [:images, stock_items: :stock_location, option_values: :option_type]
        [stock_items: :stock_location]
      end
    end
  end
end
