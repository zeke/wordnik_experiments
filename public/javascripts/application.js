$(document).ready(function(){
	
	// Passive way of hiding stuff that should be hidden.
	// This way it won't be for users with js disabled.
	$(".inactive").hide();

	// Before hiding all the inactive togglables, hard-code their height so 
	// the jQuery effect isn't choppy.
	// See http://stackoverflow.com/questions/1092245/basic-jquery-slideup-and-slidedown-driving-me-mad
	$(".togglable").each(function(){
		$(this).css("height", $(this).height());
	});
	
	$(".scrollable").scrollable({items: '#words', mousewheel: true}).navigator({
		navi:'ul#jumper'
	});
	
});

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
			color: '#C8B809',
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

	if (definition.html == "") {
		alert("definition is blank!")
	} else {
		alert("definition is not blank!")
	}
	
	json_url = 'http://api.wordnik.com/api/word.json/' + spelling + '/definitions?api_key=b39ee8d5f05d0f566a0080b4c310ceddf5dc5f7606a616f53&callback=?'
	$.getJSON(json_url, function(data) {
		defs = jQuery.map(data, function(datum, i){
			return "<p>" + datum.text + "</p>";
	    });
	  definition.html(defs.join("\n"));
	});

}

function dump(obj) {
    var out = '';
    for (var i in obj) {
        out += i + ": " + obj[i] + "\n";
    }

    alert(out);

    // or, if you wanted to avoid alerts...

    var pre = document.createElement('pre');
    pre.innerHTML = out;
    document.body.appendChild(pre)
}

jQuery.fn.fadeToggle = function(speed, easing, callback) {
    return this.animate({opacity: 'toggle'}, speed, easing, callback);
};
