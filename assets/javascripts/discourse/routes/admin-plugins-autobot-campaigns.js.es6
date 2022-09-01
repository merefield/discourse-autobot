import Campaign from 'discourse/plugins/discourse-autobot/discourse/models/campaign';
import { ajax } from 'discourse/lib/ajax';
import DiscourseRoute from "discourse/routes/discourse";

export default DiscourseRoute.extend({
  model() {
    return ajax("/autobot/campaigns.json").then(result => {
      return result.campaigns.map((v) => {
        if (("true", "false").includes(v.include_description)) {
          v.include_description = v.include_description === "true";
        }
        if (("true", "false").includes(v.tag_channel)) {
          v.tag_channel = v.tag_channel === "true";
        }
        return Campaign.create(v)
      });
    });
  }
});
