class CustomSpreeHooks < Spree::ThemeSupport::HookListener

  # add our navigation tab
  insert_after :admin_tabs do
	  %( <%= tab :greetings %> )
  end

end