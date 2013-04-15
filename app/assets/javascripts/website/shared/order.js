var tour_price = [];
function recaculate_price(){
  if (tour_price.length < 4) return;
  var total_amount = 0;
  $('#room_table tr').each(function(){
    var amount = tour_price[$(this).find('select').val() - 1];
    $(this).find('.amount').text(amount);
    total_amount += amount;
  });
  $('#total_amount').text(total_amount);
}
function add_room(){
  room_index++;
  var rid = 'room_' + room_index;
  var row = "<tr id='"+ rid +"'>" +
      "<td>Room</td>" +
      "<td>&nbsp;&nbsp;PAX:</td>" +
      "<td><select name='num_adult[]' onchange='recaculate_price()'><option>1</option><option>2</option><option>3</option><option>4</option></select></td>" + 
      "<td>&nbsp;&nbsp;Amount:</td>" + 
      "<td class='amount'></td>" +
      "<td></td>" +
      "<td>&nbsp;|&nbsp;<a href='javascript:remove_room(\""+ rid +"\");' class='button green small'>remove</a></td>" +
    "</tr>";
    $('#room_table').append(row);
    recaculate_price();
}
function date_to_string(date){
  var m = date.getMonth() + 1;
  var d = date.getDate();
  return date.getFullYear() + '.' + (m<10?'0'+m:m) + '.' + (d<10?'0'+d:d);
}

var room_index = 1;
function remove_room(rid){
  $('#' + rid).remove();
  recaculate_price();
}
function new_order(){
  $.getScript('/tours/1/order');
/*
  $('.dialog-normal')
    .dialog('option', 'title', 'New Order *')
    .dialog('open');
*/
}
