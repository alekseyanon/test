module LandmarkDescriptionHelper
  def render_category_tree(tree, prefix = "")
    return "" unless tree
    tree.each_with_index.inject("") do |html, ((name, children), index)|
      next_prefix = index.zero? ? "#{prefix} / #{name}" :
          "<span style='opacity:0'>#{prefix}</span> / #{name}"
      html + (children ? render_category_tree(children, next_prefix) : next_prefix + "<br>")
    end.html_safe
  end
end