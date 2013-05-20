$(function(){
  $("#pay_credit_card_card_number").validateCreditCard(
    function(e){
    if(e.card_type==null){
      $(".cards li").removeClass("off");
      $("#pay_credit_card_card_number").removeClass("valid");
      $('#pay_credit_card_card_type').val('');
      calculate_credit_card_service_fee();
      return
    }
    $(".cards li").addClass("off");
    $('#pay_credit_card_card_type').val(e.card_type.name);
    calculate_credit_card_service_fee();
    $(".cards ."+e.card_type.name).removeClass("off");
    if (e.length_valid&&e.luhn_valid) {
      $("#pay_credit_card_card_number").addClass("valid");
      $('#pay_button').removeAttr('disabled');
    } else {
      $("#pay_credit_card_card_number").removeClass("valid");
      $('#pay_button').attr('disabled', 'disabled');
    }
    } ,{accept:["visa","mastercard","amex"]})
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
function validate_cc_payment(f){
  var reg = /^(\d{2})[^\d]?(\d{2})$/;
  var result = $('#pay_credit_card_valid_date').val().trim().match(reg);
  if (result == null){
    alert('Please input Expiry Date');
    $('#pay_credit_card_valid_date').select().focus();
    return false;
  }
  var mm = parseInt(result[1]);
  var yy = parseInt(result[2]);
  if (!(mm>0 && mm<=12 && yy>=13 && yy<50)) {
    alert('Invalid Expiry Date!');
    $('#pay_credit_card_valid_date').select().focus();
    return false;
  }

  reg = /^\d{3}$/;
  result = $('#pay_credit_card_csc').val().trim().match(reg);
  if (result == null){
    alert('Please input CVV');
    $('#pay_credit_card_csc').select().focus();
    return false;
  }
  if ($('#pay_credit_card_full_name').val().trim().length < 3){
    alert('Please input Name On Card');
    $('#pay_credit_card_full_name').select().focus();
    return false;
  }
  if ($('#tel').val().trim().length < 3){
    alert('Please input Tel');
    $('#tel').select().focus();
    return false;
  }
  if ($('#address').val().trim().length < 3){
    alert('Please input Billing Address');
    $('#address').select().focus();
    return false;
  }
  if ($('#state').val().trim().length < 1) {
    alert('Please input State');
    $('#state').select().focus();
    return false;
  }
  if ($('#country').val().trim().length < 1){
    alert('Please input Country');
    $('#country').select().focus();
    return false;
  }
  if ($('#zipcode').val().trim().length < 2){
    alert('Please input ZIP code');
    $('#zipcode').select().focus();
    return false;
  }
  return true;
}
