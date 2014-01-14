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
            ;

            ted_log("adminButtonState: " + adminButtonState);


        }
    )

}


function adminMenuOpen(){

    $(".edit-controls").show()
    $(".admin").attr('state',"open");
    $(".artistArea").addClass("span8").removeClass("span10");

}


function adminMenuClose(){

    $(".edit-controls").hide();
    $(".admin").attr('state',"closed");
    $(".artistArea").removeClass("span8").addClass("span10");


}