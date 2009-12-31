# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def js_contants
    javascript_tag do
    end
  end
  
  def form_remote_tag(options = {}, &block)
    options[:html] ||= {}
    options[:html][:onsubmit] = "jQuery(this).checkFormFieldsAlt();#{options[:html][:onsubmit]}"
    super
  end
  
  def form_tag(url_for_options = {}, options = {}, *parameters_for_url, &block)
    options[:onsubmit] = "jQuery(this).checkFormFieldsAlt();#{options[:onsubmit]}"
    super
  end
  
  def indicator(options={})
    options.reverse_merge!(:style=> "display:none")
    image_tag('indicators/primary.gif', options)
  end
  
  def cdn_jquery_ui
    "http://ajax.googleapis.com/ajax/libs/jqueryui/1.7.2/jquery-ui.min.js"
  end
  
  def cdn_jquery_ui_css
    "http://ajax.googleapis.com/ajax/libs/jqueryui/1.7.2/themes/redmond/jquery-ui.css"
  end
  
  # jquery page load helpers
  def on_ready_without_javascript(concat_data=true, &block)
    content = capture(&block)
    data    = "$(document).ready(function() {" +  content + "});";
    concat_data ? concat(data) : data
  end
  
  def on_ready(&block)
    content = on_ready_without_javascript(false, &block)
    concat(javascript_tag(content))
  end
  
  def on_page_ready(&block)
    content_for :page_ready_javascript, capture(&block)
  end
  # jquery page load helpers - end
  
  def friendship_status_for(user)
    return unless user
    
    follow_link     = link_to_remote('follow', :url=> relationships_path("relationship[user_id]"=> user.id))
    friendship_link = link_to_remote('be-friend', :url=> relationships_path("relationship[user_id]"=> user.id, "relationship[friendship_requested]"=> true))
    
    if current_user.friend_with?(user)
      "Friend"
    elsif current_user.following?(user)
      "Following | " + friendship_link
    else
      "#{follow_link} | #{friendship_link}"
    end
  end
  
  def with_data_for(records, &block)
    if records.blank?
      concat("<div class='no-data'>[No data found]</div>")
    else
      concat(capture(&block))
    end
  end
  
end
