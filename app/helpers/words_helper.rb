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
  
end
