require 'action_view/template/handlers/liquid'

ActionView::Template.register_template_handler :liquid, ActionView::Template::Handlers::Liquid

Liquid::Template.register_filter(LiquidFilters)