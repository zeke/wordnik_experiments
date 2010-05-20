module WordsHelper
  
  # def draw_tail(words)
  #   words.map do |word|
  #     div_content = []
  #     div_content << link_to(word.spelling, "http://www.wordnik.com/words/#{word.spelling}", :class => cycle("even", "odd"))
  #     div_content << info_pair("Lookups", content_tag(:p, word.lookup_count))
  #     div_content << info_pair("Favorites", content_tag(:p, word.favorite_count))
  #     div_content << info_pair("Lists", content_tag(:p, word.list_count))
  #     div_content << info_pair("Comments", content_tag(:p, word.comment_count))
  #     content_tag :div, div_content.join("\n"), :class => "word"
  #   end.join("\n")
  # end
  
  def filter_summary
    out = []
    out << "Words"
    out << "containing &lsquo;#{params[:q]}&rsquo;" if params[:q].present?
    out << "sorted by "
  end
  
  def jumper(words)
    items = words.map do |word|
      content_tag(:li, link_to(word.spelling, "#word_container_#{word.id}"), :id => "jumper_#{word.id}")
    end
    content_tag(:ul, items.join("\n"), :id => "jumper")
  end
  
# / %ul#jumper
# /   - num_links = 20
# /   - (0...num_links).each do |i|
# /     - index = (i.to_f/num_links.to_f * @words.size.to_f).to_i
# /     - logger.debug index.to_s.red_on_yellow
# /     - word = @words[index]
# /     %li= link_to(word.spelling, "#word_container_#{word.id}")
      
end
