function sign_in(){
  //var token = $('meta[name="csrf-token"]').attr('content');
  $.ajax({
    url: '/users/sign_in.json',
    type: 'POST',
    dataType: 'json',
    data: {user: {email: $('#signin_email').val(), password: $('#signin_psw').val()}},
    success: function(data, textStatus, xhr) {
      if (textStatus == 'success'){
        close_signin();
        $.getScript('/home/get_signin_status');
      }
    },
    error: function(xhr, textStatus, error){
      alert("Sign in ERROR:\n\n" + $.parseJSON(xhr.responseText).error );
      $('#signin_email').select().focus();
    }
  });
}
function show_signin(){
  $('#sign_in_popup').slideDown('slow');
}
function close_signin(){
  $('#sign_in_popup').slideUp('slow');
}

function check_user_login(){
  return $('#sign_in_popup').length == 0;
}
