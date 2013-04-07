$(function(){
  $(".vertical.maestro").hide().css({opacity:0});
  $("#pay_credit_card_card_number").validateCreditCard(
    function(e){
    if(e.card_type==null){
      $(".cards li").removeClass("off");
      $("#pay_credit_card_card_number").removeClass("valid");
      $(".vertical.maestro").slideUp({duration:200}).animate(
        {opacity:0},
        {queue:!1,duration:200}
        );
      $('#pay_credit_card_card_type').val('');
      calculate_credit_card_service_fee();
      return
    }
    $(".cards li").addClass("off");
    $('#pay_credit_card_card_type').val(e.card_type.name);
    calculate_credit_card_service_fee();
    $(".cards ."+e.card_type.name).removeClass("off");
    e.card_type.name === "maestro" ? $(".vertical.maestro").slideDown({duration:200}).animate({opacity:1},{queue:!1}) : $(".vertical.maestro").slideUp({duration:200}).animate({opacity:0},{queue:!1,duration:200});
    if (e.length_valid&&e.luhn_valid) {
      $("#pay_credit_card_card_number").addClass("valid");
      $('#pay_button').removeAttr('disabled');
    } else {
      $("#pay_credit_card_card_number").removeClass("valid");
      $('#pay_button').attr('disabled', 'disabled');
    }
    } ,{accept:["visa","visa_electron","mastercard","maestro","discover"]})
});

function calculate_credit_card_service_fee(){
  var card_type = $('#pay_credit_card_card_type').val();
  var amount = parseFloat($('#pay_credit_card_amount').val());
  var rate = 0;
  if (card_type.length > 0 && credit_card_rate.length>0){
    rate = get_rate(card_type);
    if (rate==0) rate = get_rate('default');
  }
  var fee = amount * rate / 100;
  var tot = amount + fee;
  $('#pay_credit_card_service_fee').val(fee);
  $('#pay_credit_card_total_amount').val(tot);
}
function get_rate(card_type){
  var name_pos = credit_card_rate.indexOf(card_type);
  if (name_pos<0) return 0;
  var s_pos = credit_card_rate.indexOf('|', name_pos) + 1;
  var e_pos = credit_card_rate.indexOf('|', s_pos);
  var rate = parseFloat(credit_card_rate.substring(s_pos, e_pos));
  if (isNaN(rate)) rate = 0;
  return rate;
}

