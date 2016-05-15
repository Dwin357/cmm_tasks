$(document).ready(function() {
  list_group_toggle();
  async_listeners();
  
});

var async_listeners = function() {
  
  async_get_new();
  async_cancel();
  async_get_edit();
  async_post();
  async_patch();
  async_delete();

  // set_async_delete();
  // async_delete();
};




var async_get_new = function() {
  $('body').on('click', '.c-link', function(event){
    event.preventDefault();

    var request = $.get({
      url: $(this).attr("href")
    });

    request.done(function(response) {
      $(event.target).closest(".task-headline").append(response);
    });
  });
};

var async_get_edit = function() {
  $('body').on('click', '.u-link', function(event) {
    event.preventDefault();

    var request = $.get({
      url: $(this).attr("href")
    });

    request.done(function(response) {
      $(event.target).closest(".nested-object").replaceWith(response);
    });
  });
};

var async_cancel = function() {
  $('body').on('click', '.cncl', function(event) {
    event.preventDefault();

    if ($(event.target).closest("form").hasClass("nested-post-form")) {
      $(event.target).closest(".nested-form-group").remove();
    }

    if ($(event.target).closest("form").hasClass("nested-patch-form")) {
      var request = $.get({
        url: $(event.target).closest("form").attr("action")
      });
      request.done(function(response) {
        $(event.target).closest(".nested-form-group").replaceWith(response);
      });
    }
  });
};

var async_post = function() {
  $('body').on('submit', '.nested-post-form', function(event){
    event.preventDefault();
    
    var request = $.ajax({
      url:      $(this).attr("action"),
      method:   "POST",
      data:     $(this).serialize(),
      dataType: "json" 
    });

    request.success(function(response) {
      $(event.target).closest(".nested-object").find(".entries-container").prepend(response["response"]);
      $(event.target).closest(".nested-form-group").remove();
    });

    request.fail(function(response) {
      $(event.target).closest(".nested-form-group").replaceWith(response["response"]);
    });
  });
};

var async_patch = function() {
  $('body').on('submit', '.nested-patch-form', function(event) {
    event.preventDefault();

    var request = $.ajax({
      url:      $(this).attr("action"),
      method:   "PUT",
      data:     $(this).serialize(),
      dataType: "json"
    });

    request.done(function(response){
      $(event.target).closest(".nested-form-group").replaceWith(response["response"]);
    });
  });
};

var async_delete = function() {
  set_delete_to_async();
  $('body').on('click', '.d-link', function(event) {
    $(event.target).closest(".nested-object").remove();
  });
};

var set_delete_to_async = function () {
  $('.d-link')
    .removeAttr("data-method")
    .attr( "data-remote", "true" );
};

// var async_delete = function() {
//   $('body').on('clik', '.list-group-delete', function(event){
//     var request = $.ajax({
//       url: $(this).attr("href"),
//       method: "DELETE"
//     });


//     request.success(function(){
//       $(event.target).closest(".nested-collection").remove();
//       alert("Successfully Deleted");
//     });
//   })
// };


// var async_patch = function() {
//   $('body').on('submit', '.nested-patch-form', function(event){
//     event.preventDefault();

//     var request = $.ajax({
//       url: $(this).attr("action"),
//       method: "PATCH",
//       data: $(this).serialize(),
//       dataType: "json"
//     });

//     request.done(function(response){
//       $(event.target).closest(".nested-form-group").replaceWith(response['response']);
//     });
//   });
// };


var list_group_toggle = function() {
  $('body').on('click', '.list-group-link', function() {
    $('.toggle-icon', this)
      .toggleClass('glyphicon-chevron-right')
      .toggleClass('glyphicon-chevron-down');
    $('.truncated-note', this)
      .toggleClass('hidden');
    $(this).siblings('.cud-buttons').children(".cud-link").toggleClass('hidden');
    pass_on_ribbon(this);
  });
};

var pass_on_ribbon = function(el) {
  if ($(el).attr("data-target").match(/#task-/) != null) {
    $(el).siblings(".ribbon-object")
      .toggleClass('hidden');
  }
};