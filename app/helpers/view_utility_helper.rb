module ViewUtilityHelper
  def wrap(content, tag)
    raw "<#{tag}>#{content}</#{tag}>"
  end

  def to_html(html)
    raw html
  end

  
  def render_gutter_object(obj)
  end
end