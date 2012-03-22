(function($) {
 $('#edit').click(function(event) {

            var iD = $(this).attr('name');
            alert ($('#edit_title').text())
            $('#'+iD).html('<a href="/'+iD+'">'+$('#edit_title').text());
            $.ajax({
                url:  '/edit',
                data: { id: iD, title: $('#edit_title').text(), content: $('#edit_content').text() },
                type:       'POST',
                dataType:   'html',
                success: function(data) {
                // window.location.href = "/"+iD
                $('#'+iD).html('<a href="/'+iD+'">'+$('#edit_title').text());
                },
                error : function(data){
                    alert(data.responseText);
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
  $('#create').click(function(event) {
            $.ajax({
                url:  '/',
                data: { title: $('#edit_title').text(), content: $('#edit_content').text() },
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
  $('#tri').change(function(event) {
    // alert ($('#tri').val())
            // $.ajax({
            //     url:  '/tri',
            //     data: { tri:  $('#tri').val() },
            //     type:       'get',
            //     dataType:   'html',
            //     success: function(data) {
                window.location.href = "?tri="+$('#tri').val();
            //     },
            //     error : function(data){
            //         //alert(data.responseText);
            //     }
            // });
        }); 
  // MAIN
  $(function() {
    // Replace submit button label !! A11Y
    // $('input[type="submit"]').val('O');
  });
})(jQuery);












