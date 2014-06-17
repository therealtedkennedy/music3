// Sets csrf-token for all ajax request
$(document).ajaxSend(function(e, xhr, options) {
    $('.close').click();
    var token = $("meta[name='csrf-token']").attr("content");
    xhr.setRequestHeader("X-CSRF-Token", token);
});