function adminMenuClick() {

    $('.admin').click(function(event) {
            ted_log("clicked")
            event.preventDefault();
            var adminButtonState = $(this).attr('state')

            if (adminButtonState == "open") {
                adminMenuClose()
            }

            else if ((adminButtonState == "closed")) {
                adminMenuOpen()
            }

            ted_log("adminButtonState: " + adminButtonState);


        }
    );
}

function bindMenuItems(){
    $('.id_artist-admin').click(function(){
        $('.id_main-menu').hide();
        $('#artist-menu').show();
    });

    $('.id_album-admin').click(function(){
        $('.id_main-menu').hide();
        $('#album-menu').show();
    });

    $('.id_song-admin').click(function(){
        $('.id_main-menu').hide();
        $('#song-menu').show();
    });

    $('.id_back').click(function(){
        $('.sub-menu').hide();
        $('.id_main-menu').show();
    });

    $('.id_list-item-link').click(function(ev){
        var path = $(ev.target).find('a').attr('href');
        if(path)
            window.location = path; 
    });

    $('.album-sub-trigger').click(function(ev){
        var submenu = $(ev.currentTarget).next();
        if(submenu.css('display') === "none")
            submenu.show();
        else
            submenu.hide();
    });

    $('#gsToggle').bind('toggleOptOut', function(data){
        $(this).val(data.isChecked);
    });
}

function adminMenuOpen(){
    $(".edit-controls").show()
    $(".admin").attr('state',"open");
    $(".artistArea").addClass("span8").removeClass("span10");

    if(!$('#gsToggle').val() && $('.id_main-menu').hasClass('can-edit'))
        $('body').gettingstarted($('#gsToggle'));
}

function adminMenuClose(){
    $(".edit-controls").hide();
    $(".admin").attr('state',"closed");
    $(".artistArea").removeClass("span8").addClass("span10");
}