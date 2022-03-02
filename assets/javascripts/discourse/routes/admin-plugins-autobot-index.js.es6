import DiscourseRoute from "discourse/routes/discourse";

export default DiscourseRoute.extend({
  beforeModel: function() {
    this.transitionTo("adminPlugins.autobot.campaigns");
  }
});
