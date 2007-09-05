# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def label_for(id, name)
    id.nil? ? name : "<label for=\"#{id}\">#{name}</label>"
  end
  
  def tag_id(tag)
    result = nil
    tag.scan(/ id\=\"(.*?)\"/){|s|result = s}
    return result
  end

  def radio_group(object_name, method, hash_array, &proc)
    hash_array = hash_array.to_hash_array if hash_array.respond_to?(:hash_array)
    result = ''
    hash_array.each do |hash|
      radio = radio_button(object_name, method, hash[:id])
      radio_id = tag_id(radio)
      label = label_for(radio_id, hash[:name])
      frag = proc ? proc.call(radio, label, hash, radio_id) : (radio + label)
      result << frag
    end
    return result
  end

end
