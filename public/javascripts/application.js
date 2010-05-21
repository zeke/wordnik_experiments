$(document).ready(function(){
	
	// http://github.com/citrusbyte/jquery-watermark
	$("form#filter").watermark();
	
	// Passive way of hiding stuff that should be hidden.
	// This way it won't be for users with js disabled.
	$(".inactive").hide();

	// Before hiding all the inactive togglables, hard-code their height so 
	// the jQuery effect isn't choppy.
	// See http://stackoverflow.com/questions/1092245/basic-jquery-slideup-and-slidedown-driving-me-mad
	$(".togglable").each(function(){
		$(this).css("height", $(this).height());
	});
	
	adaptToScale()
	var adaptToScaleInterval = setInterval("adaptToScale()", 500);
	
	// $(".scrollable").scrollable({items: '#words', mousewheel: true}).navigator({
	// 	navi:'ul#jumper'
	// });
	
	// $('#words_container').jScrollHorizontalPane({
	// 	scrollbarHeight:20, 
	// 	scrollbarMargin:0,
	// 	reset: true // account for changes in content
	// });
	
});

function adaptToScale() {
	
	// Adjust #words width
	var width = 0
	$('#words div.word_container').each(function() {
    width += $(this).outerWidth(true)
	});
	
	width += 1000 // Account for expanded words
	// console.log("width:" + width)
	
	$("#words").css("width", width)
	
	// Adjust #words_container height
	$("#words_container").css("height", $(window).height() - $('#header').outerHeight() - 20)
	
	// Adjust #words_container width
	$("#words_container").css("width", $(window).width())
}

function highlightWord(id, spelling) {
	var container = $('#word_container_'+id)
	var info = $('#info_'+id)
	var link = $('#word_container_'+id+' a:first')
	var definition = $('#definition_'+id)
	var jumper = $('#jumper_'+id+' a:first')

	if (container.hasClass('active')) {
		
		// Hide word info
		definition.fadeToggle();
		info.slideToggle("fast", function() {
		  link.animate({
				color: (link.hasClass('odd') ? "#CCC" : "#333"),
				paddingLeft: '0',
				paddingRight: '0'
		  });
		});

	} else {
		
		// Show word info
	  link.animate({
			color: '#F5354C',
			paddingLeft: '50',
			paddingRight: (500 - link.width())
	  }, 500, function() {
			info.slideToggle("slow");
			definition.fadeToggle();
	  });
		
	}
	
	// These things happen whether opening or closing..
	container.toggleClass('active');
	jumper.toggleClass('open');
	
	json_url = 'http://api.wordnik.com/api/word.json/' + spelling + '/definitions?api_key=b39ee8d5f05d0f566a0080b4c310ceddf5dc5f7606a616f53&callback=?'
	$.getJSON(json_url, function(data) {
		defs = jQuery.map(data, function(datum, i){
			return "<li>" + datum.text + "</li>";
	    });
		defs.push('<li><a href="http://www.wordnik.com/words/' + spelling + '" target="_blank">&raquo; wordnik.com/words/' + spelling + '</a></li>');
	  definition.html(defs.join("\n"));
	});

}

jQuery.fn.fadeToggle = function(speed, easing, callback) {
    return this.animate({opacity: 'toggle'}, speed, easing, callback);
};
