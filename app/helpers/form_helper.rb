module FormHelper
  def self.included(base)
    ActionView::Base.default_form_builder = CustomFormBuilder
  end

  class CustomFormBuilder < ActionView::Helpers::FormBuilder
    def adjustment_field(name, options={})
      number = @template.number_field(@object_name, name, options.merge(:value => @object[name]))
      if !@object.send("#{name}_percentage") || @object.new_record?
        hidden = @template.hidden_field(@object_name, "#{name}_percentage", :value => false)
        button = @template.link_to('$', '#currency_percent', :'data-type' => 'currency', :class => 'btn btn-primary')
      else
        hidden = @template.hidden_field(@object_name, "#{name}_percentage", :value => true)
        button = @template.link_to('%', '#currency_percent', :'data-type' => 'percent', :class => 'btn btn-primary')
      end
      span = @template.content_tag(:span, button, :class => 'input-group-btn')
      @template.content_tag(:div, number + hidden + span, :class => 'adjustment input-group')
    end
    
    def currency_field(name, options={})
      hidden = @template.hidden_field(@object_name, name, :value => @object[name])
      currency = @template.number_field(@object_name, "#{name}_decimal", options.reverse_merge(:step => '0.01', :min => 0, :value => _pennies_to_decimal(@object[name])))
      @template.content_tag(:span, hidden + currency, :class => 'currency')
    end
    
    def image_field(name, options={})
      
    end
    
    private
    
    def _pennies_to_decimal(pennies)
      pennies.to_f / 100
    end
  end
end