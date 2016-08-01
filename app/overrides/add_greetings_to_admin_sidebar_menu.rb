Deface::Override.new(
  virtual_path: 'spree/layouts/admin',
	name: 'greetings_admin_sidebar_menu',
  insert_bottom: '#sidebar-product',
	partial: 'spree/admin/shared/greetings_sidebar_menu'
)