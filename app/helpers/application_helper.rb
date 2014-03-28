module ApplicationHelper
  include ActionView::Helpers::NumberHelper
  
  def namespace
    params[:controller].split("/").first
  end
  
  def namespace_controller
    params[:controller]
  end
  
  def current_namespace?(current_namespace)
    namespace == current_namespace
  end
  
  def current_controller?(current_controller)
    params[:controller] == current_controller
  end
  
  def current_action?(current_action)
    params[:action] == current_action
  end
  
  def pennies_to_decimal(pennies)
    pennies.to_f / 100
  end
  
  def currency(pennies, options={})
    number_to_currency(pennies_to_decimal(pennies), options)
  end
  
  def barcode(data)
    "data:image/png;base64,#{Base64.encode64(Barby::Code39.new(data).to_png)}"
  end
  
  def qr_code(data)
    "data:image/svg+xml;charset=utf-8;base64,#{Base64.encode64(Barby::QrCode.new(data).to_svg)}"
  end
  
  def link_to_add_fields(name, f, association, params={})
    new_object = f.object.send(association).klass.new(params)
    new_object.account = current_account if new_object.respond_to?(:account)
    id = new_object.object_id
    fields = f.fields_for(association, new_object, child_index: id) do |builder|
      render(association.to_s.singularize + "_fields", f: builder)
    end
    link_to(name, '#', class: "add_fields button", data: {id: id, fields: fields.gsub("\n", "")})
  end
  
  def flattened_tree_for_select(collection, depth=0)
    tree = []
    collection.each do |item|
      if depth > 0
        tree.push OpenStruct.new({:id => item.id, :name => "#{'-' * depth} #{item.name}"})
      else
        tree.push OpenStruct.new({:id => item.id, :name => item.name})
      end
      tree.concat flattened_tree_for_select(item.children, depth + 1)
    end
    return tree
  end
  
  def silent_url_for(options = nil)
    begin
      url_for(options)
    rescue
      '#'
    end
  end
  
  def flash_class(level)
    case level
    when :notice then "alert-info"
    when :error then "alert-error"
    when :alert then "alert-warning"
    end
  end
end