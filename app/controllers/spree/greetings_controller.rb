module Spree
  class GreetingsController < Spree::StoreController
    
    before_action :load_greeting, only: :show
    before_action :load_taxon, only: :index

    rescue_from ActiveRecord::RecordNotFound, :with => :render_404
    helper 'spree/taxons'

    respond_to :html

    def index
	  #@greetings = @searcher.retrieve_greetings.includes(:possible_promotions)
		@greetings = Greeting.all
      @taxonomies = Spree::Taxonomy.includes(root: :children)
    end

    def show
		@variants = @greeting.variants_including_master.
                           #spree_base_scopes.
                           active(current_currency).
                           includes([:option_values, :images])
      #@taxon = params[:taxon_id].present? ? Spree::Taxon.find(params[:taxon_id]) : @greeting.taxons.first
      redirect_if_legacy_path
    end

    private

      def accurate_title
        if @greeting
          @greeting.meta_title.blank? ? @greeting.name : @greeting.meta_title
        else
          super
        end
      end

      def load_greeting
        if try_spree_current_user.try(:has_spree_role?, "admin")
          @greetings = Greeting.with_deleted
        else
          @greetings = Greeting.active(current_currency)
        end
        @greeting = @greetings.includes(:variants_including_master).friendly.find(params[:id])
      end

      def load_taxon
        @taxon = Spree::Taxon.find(params[:taxon]) if params[:taxon].present?
      end

      def redirect_if_legacy_path
        # If an old id or a numeric id was used to find the record,
        # we should do a 301 redirect that uses the current friendly id.
        if params[:id] != @greeting.friendly_id
          params.merge!(id: @greeting.friendly_id)
          return redirect_to url_for(params), status: :moved_permanently
        end
      end

  end
end