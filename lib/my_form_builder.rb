class MyFormBuilder < ActionView::Helpers::FormBuilder
  ErrorSeparator = "<br />"

  def wrapper(options = {}, &block)
    element  = options[:element] || 'div'
    cls      = options[:class] || "#{object_name}_wrapper".gsub(/[^a-zA-Z0-9-_]/, '')
    @template.concat "<#{element} class='wrapper #{cls}'>#{@template.capture &block}</#{element}>"
  end
  
  def text_field(method, options = {})
    value = @object.send(method.to_sym)
    
    if blur_text = options[:blur_text]
      options[:onblur]        = "if(this.value=='') {this.value='#{blur_text}';$(this).addClass('blurred')}"
      options[:onfocus]       = "if(this.value=='#{blur_text}') {this.value='';$(this).removeClass('blurred')}"
      options[:autocomplete]  = "off"
      if value.blank?
        options[:value]       = blur_text 
        options[:class]       ||= ""
        options[:class]       += " blurred"
      end
    end

    errors = @object.errors.on(method.to_sym)
    unless errors.blank?
      options[:title] = Array === errors ? errors.join(ErrorSeparator) : errors
    end
    
    super
  end
  
  def password_field(method, options = {})
    value = @object.send(method.to_sym)

    errors = @object.errors.on(method.to_sym)
    unless errors.blank?
      options[:title] = Array === errors ? errors.join(ErrorSeparator) : errors
    end
    
    super
  end

  def text_area(method, options = {})
    value = @object.send(method)
    
    if blur_text = options[:blur_text]
      options[:onblur]        = "if(this.value==''){this.value='#{blur_text}';$(this).addClass('blurred')}"
      options[:onfocus]       = "if(this.value=='#{blur_text}') {this.value='';$(this).removeClass('blurred')}"
      options[:autocomplete]  = "off"
      if value.blank?
        options[:value]       = blur_text 
        options[:class]       ||= ""
        options[:class]       += " blurred"
      end
    end
    
    errors = @object.errors.on(method.to_sym)
    unless errors.blank?
      options[:title] = Array === errors ? errors.join(ErrorSeparator) : errors
    end
    
    super
  end
end