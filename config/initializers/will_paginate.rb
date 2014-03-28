require 'will_paginate/view_helpers/link_renderer'
require 'will_paginate/view_helpers/action_view'

WillPaginate.per_page = 10

module WillPaginate
  module ActionView
    def will_paginate(collection = nil, options = {})
      options[:renderer] ||= BootstrapLinkRenderer
      super.try :html_safe
    end
 
    class BootstrapLinkRenderer < LinkRenderer
      protected
      
      def html_container(html)
        tag(:ul, html, :class => 'pagination pagination-sm')
      end
      
      def gap
        text = @template.will_paginate_translate(:page_gap) { '&hellip;' }
        tag :li, link(text, '#'), :class => 'disabled'
      end
 
      def page_number(page)
        tag :li, link(page, page, :rel => rel_value(page)), :class => ('active' if page == current_page)
      end
 
      def previous_or_next_page(page, text, classname)
        tag :li, link(text, page || '#'), :class => [classname[0..3], classname, ('disabled' unless page)].join(' ')
      end
    end
  end
end