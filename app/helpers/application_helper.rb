module ApplicationHelper

  def generate_chart(responses)    
    lc = GoogleChart::LineChart.new('960x300', "", false)
    lc.title_color = '999999'


    # Find average count across all responses
    # lc.max_value = response['frequency'].map{|r| r}


    index = 0
    responses.each_pair do |word, response|
      bar_values = []
      1800.upto(1995) do |year|
        year_count_pair = response['frequency'].find { |f| f['year'].to_i == year }
        bar_values << (year_count_pair ? year_count_pair['count'] : 0)
      end
      lc.data word, bar_values, COLORS[index]
      index += 1
    end
    image_tag(lc.to_url)
  end
  
end