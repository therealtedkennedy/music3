
/* hides floating content, and makes admin screen appear when edit pages load normally with out ajax*/
$(document).ready(function(){
    $('.adminLink').removeClass("collapsed");
    $('.adminLink').addClass("expanded");
    $('.artistLogoArea').hide();
    $(".navArea").hide();
});
