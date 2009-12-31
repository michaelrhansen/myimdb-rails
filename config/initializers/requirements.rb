silence_warnings do
  ActionView::Helpers::InstanceTag::DEFAULT_FIELD_OPTIONS = { "size" => 40 }.freeze 
end

require 'has_many_polymorphs'
require 'open-uri'