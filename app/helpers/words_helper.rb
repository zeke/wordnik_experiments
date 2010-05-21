module WordsHelper
  
  def filter_summary
    return "Sorry, no words found." if @words.blank? || @words.total_entries.blank?
    out = []
    out << pluralize(@words.total_entries, "word")
    out << (@words.total_entries.size==1 ? " was found" : " were found")
    if params[:q].present?
      q = params[:q].dup
      quoted_q = "&lsquo;#{q.gsub("*", "")}&rsquo;"
      out << if q.starts_with?("*")
        " that end with #{quoted_q}" 
      elsif q.ends_with?("*")
        " that start with #{quoted_q}"
      elsif q.starts_with?("list:")
        " in the list &lsquo;#{@list_title}&rsquo;"
      else
        " containing #{quoted_q}" unless q.include?("*")
      end
    end
    
    if @words.total_entries.size > 1
      out << ", sorted by #{params[:order_by].gsub("_", " ")} from #{params[:direction] == "asc" ? "least to most" : "most to least"}."
    end
    
    content_tag(:div, out.join(""), :id => "filter_summary")
  end
  
  def jumper(words)
    items = words.map do |word|
      content_tag(:li, link_to(word.spelling, "#word_container_#{word.id}"), :id => "jumper_#{word.id}")
    end
    content_tag(:ul, items.join("\n"), :id => "jumper")
  end
  
  def sort_menu
    items = []
    items << "Sort by: "
    configatron.sort_types.each do |sort_type|
      sort_param = "#{sort_type}_count"
      css = (params[:order_by] == sort_param) ? "active" : nil
      items << link(sort_type.pluralize.titlecase, words_path(build_url_params_hash({:order_by => sort_param})), :class => css)
    end
    content_tag(:ul, convert_to_list_items(items), :id => "sort_menu")
  end

  def sort_direction_menu
    items = []
    items << "Direction: "

    css = (params[:direction] == "desc") ? "active" : nil
    items << link("Most to Least", words_path(build_url_params_hash(:direction => "desc")), :class => css)

    css = (params[:direction] == "asc") ? "active" : nil
    items << link("Least to Most", words_path(build_url_params_hash(:direction => "asc")), :class => css)
    
    content_tag(:ul, convert_to_list_items(items), :id => "sort_direction_menu")
  end

  # Preserve existing params when setting up a URL
  def build_url_params_hash(hash_to_merge)
    link_params = params
    configatron.unwanted_params.each { |up| link_params.delete(up.to_sym) }
    link_params.merge(hash_to_merge)
  end
  
  def generate_chart(responses)    

    # Find highest count among all words across all time
    all_counts = @responses.map {|word, response| response['frequency'] }.flatten.map{|pair| pair['count'].to_i }.flatten
    average_count = (all_counts.get_sum.to_f / all_counts.size).to_i
    highest_count = all_counts.sort.last
    
    lc = GoogleChart::LineChart.new('960x200', "Average Count: #{average_count}", false)
    lc.title_color = '999999'    
    
    # Duration
    start_year = params[:start_year].present? ? params[:start_year].to_i : 1800
    end_year = params[:end_year].present? ? params[:end_year].to_i : 2000
    end_year = 2010 if end_year > 2010
    # start_year = end_year-10 if start_year > end_year
    duration = end_year - start_year
    
    # Axis Labels
    x_axis_num_labels = 10
    x_axis_num_labels = duration if duration < 20
    years_per_label = duration.to_f/x_axis_num_labels.to_f
    x_labels = (0..x_axis_num_labels).to_a.map{|i| (start_year + i.to_f*years_per_label).round }
    lc.axis :x, :labels => x_labels
    lc.axis :y, :labels => [0,highest_count]

    index = 0
    responses.each_pair do |word, response|
      bar_values = []
      start_year.upto(end_year) do |year|
        year_count_pair = response['frequency'].find { |f| f['year'].to_i == year }
        bar_values << (year_count_pair ? year_count_pair['count'] : 0)
      end
      lc.data word, bar_values, COLORS[index]
      index += 1
    end

    
    image_tag(lc.to_url)
  end

      
end
