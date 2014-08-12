$(document).ready(function($){
	$.contents = [
		{
			title: "Welcome to Three Repeater",
			message: "The artist admin tab is where you control everything about your artist. Upload songs, create albums, and edit appearance.",
			buttonText: "next"
		},
		{
			title: "What Everything Does",
			message: "Artist Profile - Where you control information related to the artist, profile image, contact info, bio, etc.<br/><br/>Songs - Manage all your songs.<br/><br/>Albums - Manage collections of uploaded songs.",
			buttonText: "next"
		},
		{
			title: "Now Let's Get Started!",
			message: 'Get started by uploading some songs!<br/>  - Click "Songs", "New Song", and add as many as you like.<br/><br/>Then create albums and get selling!</br/>  - To add an album click "Albums", "New Album".<br/><br/>Customize your page with some sweet styles.<br/>  - Click "Appearance" and start editing.',
			buttonText: "done"
		}
	];

	var html = '<div id="overlay" class="gettingstarted" style="background-color: rgba(153, 153, 153, 0.5);"><div class="modal-dialog"><div class="modal-content"><div class="modal-header"><button type="button" class="close" style="color:#999;top:11px;font-size:25px;" data-dismiss="modal"><span aria-hidden="true">×</span><span class="sr-only"></span></button><h4 class="modal-title" id="myModalLabel"></h4></div><div class="modal-body"></div><div class="modal-footer"><div class="pull-left" style="margin-top:7px;"><input type="checkbox" id="gsOptOut" style="margin:0 5px;"/><span>Don\'t show again</span></div><button type="button" class="btn btn-primary"></button></div></div></div></div>';

	$.fn.gettingstarted = function(element){
		$.element = element;
		$.item = 0
		var c = $.contents[$.item];
		this.append(html);
		var $el = this.find('.gettingstarted');
		var width = 450;
		$el.find('.modal-content').css({
			'top': '75px', 
			'left': ($(window).width() - width)/2, 
			'background-color': '#fff', 
			'font-size': '14px', 
			'line-height': '20px', 
			'position': 'absolute',
			'width': width + 'px'
		});
		$el.find('.modal-title').css({'margin': '5px 0'});
		$el.find('.modal-title').text(c.title);
		$el.find('.modal-body').html(c.message);
		$el.find('.modal-footer button').addClass(c.buttonText).text(c.buttonText);
		$('#overlay').click(function(){$.fn.close();});
		$el.find('.modal-content').click(function(ev){ev.stopPropagation();})
		$el.find('.close').click(function(){$.fn.close();});
		$el.find('.next').click(function(){
			if($(this).hasClass('done')){
				$.fn.close();
				return;
			}
			$.item += 1;
			$.fn.loadNext();
			return false;
		});
		$el.find('#gsOptOut').click(function(){
			$.element.trigger({type: 'toggleOptOut', isChecked: $(this).is(':checked')});
		});
	}
	$.fn.close = function(){
		$('#overlay').remove();
	}
	$.fn.loadNext = function(){
		var c = $.contents[$.item];
		var $el = $('.gettingstarted');
		$el.find('.modal-title').text(c.title);
		$el.find('.modal-body').html(c.message);
		$el.find('.modal-footer button').removeClass('next').addClass(c.buttonText).text(c.buttonText);
	}
});