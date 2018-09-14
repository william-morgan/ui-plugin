import { registerUnbound } from 'discourse-common/lib/helpers';

registerUnbound("fsc-helper", function(title){
  var changed_title = "DEFAULT TITLE";
  var html  = "<span>" + changed_title + "</span";
  var separator = " ";
  var min   = 0;
  var max   = 40;
  if(title.length > min && title.length < max || title.length==max){
    changed_title = title;
  }
  else{
    if(title.length > max){
        changed_title = title.substr(0, title.lastIndexOf(separator, (max-3))) + "..."; 
    }
    else{
      changed_title = title;
    }
  }
  html = "<span>" + changed_title + "</span>";
  return new Handlebars.SafeString(html);
 });



