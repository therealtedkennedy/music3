// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

//= require jquery
//= require jquery_ui
//= require jquery_ujs
//= require tree .
//= require rails.validations

//music player



 $(document).ready(function() {
    var audioSection = $('section#audio');
    $('a.html5').click(function() {

        var audio = $('<audio>', {
             controls : 'controls'
        });

        var url = $(this).attr('href');
        $('<source>').attr('src', url).appendTo(audio);
        audioSection.html(audio);
        return false;
    });
});
