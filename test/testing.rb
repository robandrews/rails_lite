require 'uri'
  
def parse_www_encoded_form(www_encoded_form)
  attributes = URI.decode_www_form(www_encoded_form)
  ret = {}
    
  attributes.each do |attribute|
    keys = parse_key(attribute[0])
      
    if keys.length == 1
      ret[keys.first] = attribute[1]
    else
      current = ret
      keys.each_with_index do |key, i|        
        current[key] = attribute[1] if i == keys.length - 1
        current[key] ||= {}     
        current = current[key]
      end
    end
  end
  ret
end

def parse_key(key)
  key.split(/\]\[|\[|\]/)
end