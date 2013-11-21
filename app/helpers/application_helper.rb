module ApplicationHelper
  def options_for_reviews(selected=nil)
    options_for_select((0..5).to_a.map { |number| [pluralize(number, "star"), number] }, selected)
  end
end
