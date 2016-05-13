$(document).ready(function() {
  list_group_toggle();
  async_get();
  set_async_delete();
});


var set_async_delete = function () {
  $('.list-group-delete')
    .removeAttr("data-method")
    .attr( "data-remote", "true" );
};

var async_get = function() {
  $('.cud-link').on('click', function(event) {
    event.preventDefault();

    var request = $.get({
      url: $(this).attr("href")
    });

    request.done(function(response) {
      $(event.target).closest(".nested-collection").replaceWith(response);
    });
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