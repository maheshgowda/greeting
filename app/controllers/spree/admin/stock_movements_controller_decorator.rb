Spree::Admin::StockMovementsController.class_eval do
      
      def index
        @stock_movements = stock_location.stock_movements.recent.
			  includes(:stock_item => { :variant => [ :product, :greeting ]}).
          page(params[:page])
      end
end
