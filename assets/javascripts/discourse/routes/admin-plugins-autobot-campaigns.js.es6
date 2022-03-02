import Campaign from 'discourse/plugins/autobot/discourse/models/campaign';
import { ajax } from 'discourse/lib/ajax';
import DiscourseRoute from "discourse/routes/discourse";

export default DiscourseRoute.extend({
  model() {
    return ajax("/autobot/campaigns.json").then(result => {
      return result.campaigns.map(v => Campaign.create(v));
    });
  }
});
