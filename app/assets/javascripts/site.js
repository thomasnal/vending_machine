$( document ).ready(function() {
  // CAROUSEL - show form thankyou after submit
  $('.carousel-item').first().addClass("active");

  // scroll to top call back button
  $("a[href='#top']").click(function() {
    $("html, body").animate({ scrollTop: 0 }, "slow");
    var modalbg =	$("body").animate({ scrollTop: 0 }, "slow");
    $("body").animate({ modalbg: 0 }, "slow");
    return false;
  });
});
