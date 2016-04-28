$(document).ready(function() {
  var isValid = false;

  $('#user_password_confirm').on('keyup', function(){
    errorFeedback();
  });
  $('#user_password').on('keyup', function(){
    errorFeedback();
  });
  $('#new_user').on('click', function(event) {
    if (!isValid)
      event.preventDefault();
  });

  var errorFeedback = function() {
    switch(passwordTest()) {
      case null:
        toggleEmpty();
        break;
      case true:
        toggleMatch();
        break;
      case false:
        toggleMismatch();
        break;
    }
  };

  var passwordTest = function() {
    var password_field         = $('#user_password').val();
    var password_field_confirm = $('#user_password_confirm').val();
    return matchChecker(password_field, password_field_confirm);
  };

  var matchChecker = function(str1, str2){
    if((str1 == "") && (str2 == ""))
      return null;
    else if((str1 == str2) && (str1 != null))
      return true;
    else
      return false;
  };

  var toggleEmpty = function(){
    $('#password-feedback').html(' ');
    $('#password-feedback').removeClass('alert alert-success');
    $('#password-feedback').removeClass('alert alert-danger');
    isValid = false;
  };

  var toggleMatch = function(){
    $('#password-feedback').html('password valid');
    $('#password-feedback').removeClass('alert alert-danger');
    $('#password-feedback').addClass('alert alert-success');
    isValid = true;      
  };

  var toggleMismatch = function(){
    $('#password-feedback').html('passwords different');
    $('#password-feedback').removeClass('alert alert-success');
    $('#password-feedback').addClass('alert alert-danger');
    isValid = false;
  };
});