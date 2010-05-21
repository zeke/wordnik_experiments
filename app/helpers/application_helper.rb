module ApplicationHelper
  
  def page_title
    "Logophilia, a Wordnik browser"
  end
  
  def stylesheets
    screen = %w(blueprint_screen application)
		out = screen.map { |stylesheet| stylesheet_link_tag(stylesheet) }
    # TODO Add Print and IE stylesheets
    # out << "<!--[if lt IE 8]>" + stylesheet_link_tag('ie') + "<![endif]-->"
    out.flatten.join("\n")
  end
  
  def enable_typekit(kit_id)
    return if offline_mode?
    "<script type=\"text/javascript\" src=\"http://use.typekit.com/#{kit_id}.js\"></script>
    <script type=\"text/javascript\">try{Typekit.load();}catch(e){}</script>"
  end

  # Be sure to load application.js last!
  def javascripts
    out = []
    files = []
    if offline_mode?
      files << %w(jquery jquery-ui)
    else
      out << google_jquery(:version => '1.4.1')
      out << google_jqueryui
    end
    # files << %w(jquery.tools.min.js jquery.watermark application)
    # jquery.dimensions functionality is allegedly rolled into jquery 1.4.2..
    # http://plugins.jquery.com/node/13691
    files << %w(jquery.mousewheel.min jScrollHorizontalPane jquery.watermark application)
    out << javascript_include_tag(files.flatten)
    out.flatten.join("\n")
  end  
  
    
end