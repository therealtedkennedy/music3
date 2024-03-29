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
    $('.id_artist-admin, .id_album-admin, .id_song-admin, .id_back, .id_list-item-link, .album-sub-trigger').unbind('click');
    $('#gsToggle').unbind('toggleOptOut');

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
        var path = $(ev.target).attr('href') || $(ev.target).find('a').attr('href');
        if(path){
            window.location = path; 
            return false;
        }
    });

    $('.album-sub-trigger').click(function(ev){
        var submenu = $(ev.currentTarget).next();
        if(submenu.css('display') === "none")
            submenu.show();
        else
            submenu.hide();
    });

    $('#gsToggle').bind('toggleOptOut', function(data){
        $(this).val(data.isChecked).trigger('change');
    });
}

function adminMenuOpen(){
    $(".edit-controls").show()

    if($(".admin").attr('state') === 'closed' && $('#gsToggle').val() !== "true" && $('.id_main-menu').hasClass('can-edit'))
        $('body').gettingstarted($('#gsToggle'));

    $(".admin").attr('state',"open");
    $(".artistArea").addClass("span8").removeClass("span10");
    bindMenuItems();
}

function adminMenuClose(){
    $(".edit-controls").hide();
    $(".admin").attr('state',"closed");
    $(".artistArea").removeClass("span8").addClass("span10");
}

function showNotification(msg){
    if($('#uploadNotice').length)
        return;
    $('.bodyArea').append('<div id="uploadNotice" class="alert alert-info"><a href="#" class="close" data-dismiss="alert">&times;</a>'+msg+'</div></html>');
    setTimeout(function(){
        $( "#uploadNotice" ).fadeOut(2000, function() {
            this.remove();
          });
    }, 3000)
}