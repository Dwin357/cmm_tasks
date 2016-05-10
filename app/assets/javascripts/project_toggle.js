$(document).ready(function() {
        
  $('.list-group-item').on('click', function() {
    $('.toggle-icon', this)
      .toggleClass('glyphicon-chevron-right')
      .toggleClass('glyphicon-chevron-down');
    $('.list-group-ud-icons', this)
      .toggleClass('hidden');
  });

});

