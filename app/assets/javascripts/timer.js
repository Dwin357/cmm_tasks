$(document).ready(function() {
  setInterval(timerIncrementor, 1000);
  setTimerAsync();
});

var timerIncrementor = function() {  
  $('.duration-display.active').each(function(){
    var duration = $(this).data("timelapsed");
    duration = duration + 1;
    $(this).data("timelapsed", duration);
    $(this).html(formatDisplayTime(duration));
  });
};

var formatDisplayTime = function(seconds) {
  var remainder = seconds;
  var hours   = Math.floor(remainder / 3600);
  remainder   = remainder - (hours*3600);
  var min     = Math.floor(remainder / 60);
  remainder   = remainder - (min*60);
  var seconds = remainder;
  return "Timer: "+hours+"."+min+"."+seconds;
};

var setTimerAsync = function(){
  asyncSave();
  asyncStart();
  asyncStop();
};

var asyncStart = function (){
  $('body').on('click', '.timer-start', function(event){
    event.preventDefault();
    $(this).closest('.form-group').children(".duration-display").addClass("active");
  });
};

var asyncStop = function() {
  $('body').on('click', '.timer-stop', function(event){
    event.preventDefault();
    $(this).closest('.form-group').children(".duration-display").removeClass("active");
  });
};

var asyncSave = function