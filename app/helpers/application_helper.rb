module ApplicationHelper

  def generate_chart(responses)    

    # Find highest count among all words across all time
    all_counts = @responses.map {|word, response| response['frequency'] }.flatten.map{|pair| pair['count'].to_i }.flatten
    average_count = (all_counts.get_sum.to_f / all_counts.size).to_i
    highest_count = all_counts.sort.last
    
    lc = GoogleChart::LineChart.new('960x200', "Average Count: #{average_count}", false)
    lc.title_color = '999999'    
    
    year_min = 1800
    year_max = 2000

    x_axis_num_labels = 10

    index = 0
    responses.each_pair do |word, response|
      bar_values = []
      year_min.upto(year_max) do |year|
        year_count_pair = response['frequency'].find { |f| f['year'].to_i == year }
        bar_values << (year_count_pair ? year_count_pair['count'] : 0)
      end
      lc.data word, bar_values, COLORS[index]
      index += 1
    end

    
    lc.axis :x, :labels => (0..x_axis_num_labels).to_a.map{|i| year_min + i*((year_max-year_min)/x_axis_num_labels)}
    lc.axis :y, :labels => [0,highest_count]
    image_tag(lc.to_url)
  end
  
end