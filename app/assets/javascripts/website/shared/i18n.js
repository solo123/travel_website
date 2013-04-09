function change_language(current_language){
  var s = location.href;
  if (current_language == 'zh'){
    s = s.replace(/\/\/zh\./i, "//www.");
    //$.get('/home/set_language_en'); 
  } else {
    s = s.replace(/\/\/www\./i, "//zh.");
    //$.get('/home/set_language_zh');
  }
  //alert(location);
  //location.reload();
  location.href = s;
}
