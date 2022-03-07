import { registerUnbound } from 'discourse-common/lib/helpers';
import { htmlSafe } from '@ember/template';


registerUnbound('fts-helper', function(date) {
    var today = moment().startOf('day').format("YYYY-MM-DD");
    var yesterday =  moment().startOf('day').subtract(1, 'days').format("YYYY-MM-DD");
    var check_date = moment(date).format("YYYY-MM-DD");
    var check_time = moment(date).format("hh:mm A");
    var html;
    var date_class = "column-date";
    if(today==check_date){
        html =  "<span class='" + date_class + "'>Today</span> <span class='column-time'>at " + check_time + "</span>";
    }
    else if(yesterday==check_date){
        html =  "<span class='" + date_class + "'>Yesterday</span> <span class='column-time'>at " + check_time + "</span>";
    }
    else{
        html = "<span class='" + date_class + "'>" + check_date + "</span> <span class='column-time'>at " + check_time + "</span>";
    }
  return htmlSafe(html);
});
