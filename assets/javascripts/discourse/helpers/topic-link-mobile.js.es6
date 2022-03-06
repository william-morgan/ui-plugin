import { registerUnbound } from "discourse-common/lib/helpers";

registerUnbound("topic-link-mobile", (topic, args) => {
  const title = topic.get("fancyTitle");
  const url = topic.linked_post_number
    ? topic.urlForPostNumber(topic.linked_post_number)
    : topic.get("lastUnreadUrl");
  var changed_title = new String();
  var separator = " ";
  var min   = 0;
  var max = 44;
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
  const classes = ["title"];
  if (args.class) {
    args.class.split(" ").forEach(c => classes.push(c));
  }

  const result = `<a href='${url}' class='${classes.join(" ")}'>${changed_title}</a>`;
  return new Handlebars.SafeString(result);
});
