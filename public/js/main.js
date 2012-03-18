(function($) {
 $('#edit').click(function(event) {
            var iD = $(this).attr('name');
            $.ajax({
                url:  '/edit',
                data: { id: iD, title: $('#edit_title').html(), content: $('#edit_content').html() },
                type:       'POST',
                dataType:   'html',
                success: function(data) {
                window.location.href = "/"+iD
                },
                error : function(data){
                    //alert(data.responseText);
                }
            });
        }); 
  $('#delete').click(function(event) {
            var iD = $(this).attr('name');
            $.ajax({
                url:  '/delete',
                data: { id: iD },
                type:       'POST',
                dataType:   'html',
                success: function(data) {
                window.location.href = "/"
                },
                error : function(data){
                    //alert(data.responseText);
                }
            });
        }); 
  // MAIN
  $(function() {
    // Replace submit button label !! A11Y
    // $('input[type="submit"]').val('O');
  });
})(jQuery);












