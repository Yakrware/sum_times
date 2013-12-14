module OptionsHelper
  def option_value(v)
    if v.is_a?(Array) 
      v.join(', ')
    elsif v.is_a?(Hash)
      v.map{|k, val| "#{k}: #{val}"}.join(', ')
    else
      v
    end
  end
end
