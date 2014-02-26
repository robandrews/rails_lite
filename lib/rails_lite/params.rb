require 'uri'

class Params
  # use your initialize to merge params from
  # 1. query string
  # 2. post body
  # 3. route params
  def initialize(req, route_params = {})
    @req = req
    if @req.query_string
      @params = parse_www_encoded_form(@req.query_string)
    elsif @req.body
      @params = parse_www_encoded_form(@req.body)
    elsif !route_params.empty?
      @params = route_params
    end
  end

  def [](key)
    @params[key]
  end

  def permit(*keys)
    @permitted_keys ||= []
    @params.keys.each do |key|
      @permitted_keys << key if keys.include?(key)
    end
  end

  def require(key)
    raise AttributeNotFoundError unless @params.keys.include?(key)
  end

  def permitted?(key)
    @permitted_keys.include?(key)
  end

  def to_s
    @params.to_s
  end

  class AttributeNotFoundError < ArgumentError; end;

  private
  # this should return deeply nested hash
  # argument format
  # user[address][street]=main&user[address][zip]=89436
  # should return
  # { "user" => { "address" => { "street" => "main", "zip" => "89436" } } }
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

  # this should return an array
  # user[address][street] should return ['user', 'address', 'street']
  def parse_key(key)
    key.split(/\]\[|\[|\]/)
  end
end
