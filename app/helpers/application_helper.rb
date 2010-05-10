module ApplicationHelper
  
  def page_title
    "Wordnik Experiments"
  end
  
  def stylesheets
    screen = %w(blueprint_screen application)
    # print = %w(print)
		out = screen.map { |stylesheet| stylesheet_link_tag(stylesheet) }
    # out << print.map { |stylesheet| stylesheet_link_tag(stylesheet, :media => 'print') }
    # TODO Add Print and IE stylesheets
    # out << "<!--[if lt IE 8]>" + stylesheet_link_tag('ie') + "<![endif]-->"
    out.flatten.join("\n")
  end
  
  def enable_typekit(kit_id)
    "<script type=\"text/javascript\" src=\"http://use.typekit.com/#{kit_id}.js\"></script>
    <script type=\"text/javascript\">try{Typekit.load();}catch(e){}</script>"
  end

  # Be sure to load application.js last!
  def javascripts
    out = []
    out << google_jquery(:local => offline_mode?)
    out << google_jqueryui(:local => offline_mode?)
    files = %w(application)
    out << javascript_include_tag(files.flatten)
    out.join("\n")
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