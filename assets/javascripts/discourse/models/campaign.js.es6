import RestModel from 'discourse/models/rest';
import Category from 'discourse/models/category';
import CampaignProvider from '../models/campaign_provider';
import CampaignSource from '../models/campaign_source';
import discourseComputed from "discourse-common/utils/decorators";

export default RestModel.extend({
  provider_id: null,
  source_id: null,
  key: null,
  category_id: null,
  topic_id: null,
  last_poll_outcome: null,
  last_poll_count: 0,
  polling_interval: 30,
  channel_name: null,
  title_keyword_filter: null,
  include_description: false,
  tag_channel: true,
  default_tags: null,
  owner_username: null,
  subscription_state: "Unknown",
  subscription_expiration_time: null,
  subscription_last_received: null,

  @discourseComputed('category_id')
  categoryName(categoryId) {
    if (!categoryId) {
      return;
    }

    const category = Category.findById(categoryId);
    if (!category) {
      return I18n.t('autopost.choose.deleted_category');
    }

    return category.get('name');
  },

  @discourseComputed('provider_id')
  providerName(providerId) {
    if (!providerId)
      return;
    return CampaignProvider.findById(providerId).name;
  },

  @discourseComputed('source_id')
  sourceName(sourceId) {
    if (!sourceId)
      return;
    return CampaignSource.findById(sourceId).name;
  }
});
