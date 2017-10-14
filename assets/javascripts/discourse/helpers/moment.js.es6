import { registerUnbound } from 'discourse-common/lib/helpers';



registerUnbound('moment', function(options, date) {
    var opts = options.hash;
    var today = moment().startOf('day').format("YYYY-MM-DD");
    var yesterday =  moment().startOf('day').subtract(1, 'days').format("YYYY-MM-DD");
    var check_date = moment(date).format("YYYY-MM-DD");
    var check_time = moment(date).format("hh:mm A");
    var html;
    var date_class = "column-date";
    if(opts.post=="true"){
        date_class += "-post";
    }
    if(today==check_date){
        html =  "<span class='" + date_class + "'>Today</span> <span class='column-time'>" + check_time + "</span>";
    }
    else if(yesterday==check_date){
        html =  "<span class='" + date_class + "'>Yesterday</span> <span class='column-time'>" + check_time + "</span>";
    }
    else{
        html = "<span class='" + date_class + "'>" + check_date + "</span> <span class='column-time'>" + check_time + "</span>";
    }
  return new Handlebars.SafeString(html);
});
