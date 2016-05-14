$(document).ready(function() {
  // set_async_delete();

  list_group_toggle();
  
  // async_get();
  // async_post();
  // async_patch();
  // async_delete();
});


var set_async_delete = function () {
  $('.list-group-delete')
    .removeAttr("data-method")
    .attr( "data-remote", "true" );
};


var async_get = function() {
  $('body').on('click', '.cu-link', function(event) {
    event.preventDefault();

    var request = $.get({
      url: $(this).attr("href")
    });

    request.done(function(response) {
      $(event.target).closest(".nested-collection").replaceWith(response);
    });
  });
};


var async_post = function() {
  $('body').on('submit', '.nested-post-form', function(event){
    event.preventDefault();

    var request = $.ajax({
      url: $(this).attr("action"),
      method: "POST",
      data: $(this).serialize(),
      dataType: "json"
    });

    request.success(function(response) {
      $(event.target).closest(".nested-form-group").replaceWith(response['response']);
    });
  });
};


var async_delete = function() {
  $('body').on('clik', '.list-group-delete', function(event){
    var request = $.ajax({
      url: $(this).attr("href"),
      method: "DELETE"
    });


    request.success(function(){
      $(event.target).closest(".nested-collection").remove();
      alert("Successfully Deleted");
    });
  })
};


var async_patch = function() {
  $('body').on('submit', '.nested-patch-form', function(event){
    event.preventDefault();

    var request = $.ajax({
      url: $(this).attr("action"),
      method: "PATCH",
      data: $(this).serialize(),
      dataType: "json"
    });

    request.done(function(response){
      $(event.target).closest(".nested-form-group").replaceWith(response['response']);
    });
  });
};


var list_group_toggle = function() {
  $('body').on('click', '.list-group-link', function() {
    $('.toggle-icon', this)
      .toggleClass('glyphicon-chevron-right')
      .toggleClass('glyphicon-chevron-down');
    $(this).siblings('.cud-buttons').children(".cud-link").toggleClass('hidden');
    pass_on_ribbon(this);
  });
};

var pass_on_ribbon = function(el) {
  if ($(el).attr("data-target").match(/#task-/) != null) {
    $(el).closest(".ribbon-object").children(".ribbon-object")
      .toggleClass('hidden');
  }
};