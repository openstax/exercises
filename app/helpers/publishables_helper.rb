module PublishablesHelper
  def name_links(object_array)
    object_array.collect{|o| name_link(o)}.join(', ').html_safe
  end
end
