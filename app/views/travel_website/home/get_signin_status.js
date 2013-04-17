$('.login-status').replaceWith("<%= j render 'travel_website/shared/login_bar' %>");
$('.login-status')
    .delay(500)
    .fadeOut().fadeIn()
    .fadeOut().fadeIn();

