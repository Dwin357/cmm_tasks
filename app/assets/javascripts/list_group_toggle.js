$(document).ready(function() {
  list_group_toggle();
  edit_item();
});


var edit_item = function() {
  $('.cud-link').on('click', function(event) {
    // event.preventDefault();
    // var request = $.ajax({
    //   url: $(this).find("a").attr("href")
    // });
    // request.done(function(response) {
    //   $(this).parentUntil("span.list-group-item").replaceWith(response);
    // });
  });
};

var list_group_toggle = function() {
  $('.list-group-link').on('click', function() {
    $('.toggle-icon', this)
      .toggleClass('glyphicon-chevron-right')
      .toggleClass('glyphicon-chevron-down');
    $(this).siblings('.cud-toggle').toggleClass('hidden');
  });
};