def load_data(d, nm_spce="")
  d.collect do |key, value|
    if Hash === value
      load_data(value, nm_spce.blank? ? key : "#{nm_spce}_#{key}")
    else
      eval((nm_spce.blank? ? "#{key}" : "#{nm_spce}_#{key}").classify + "='#{value}'")
    end
  end
end


config = YAML.load_file(File.join(RAILS_ROOT, 'config', 'configuration.yml'))
load_data(config) if config

UrlRegexp = /\Ahttp(s?):\/\/(\w+:{0,1}\w*@)?(\S+)(:[0-9]+)?(\/|\/([\w#!:.?+=&%@!\-\/]))?/i