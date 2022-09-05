# frozen_string_literal: true

describe Autopost::Youtube::PostVideo do
  fab!(:user)  { Fabricate(:user) }
  let(:push_xml) { "#{Rails.root}/plugins/discourse-autopost/spec/fixtures/files/push.xml" }
  let(:api_channel_response) { "#{Rails.root}/plugins/discourse-autopost/spec/fixtures/files/api_channel_response.txt" }
  let(:api_video_response) { "#{Rails.root}/plugins/discourse-autopost/spec/fixtures/files/api_video_response.txt" }

  before(:all) do
    SiteSetting.autopost_enabled = true
  end

  it "creates Topic with correct details" do
    stub_request(:get, "https://www.googleapis.com/youtube/v3/channels?id=CHANNEL_ID&key=&part=snippet").
    with(
      headers: {
      'Content-Length'=>'0',
      'User-Agent'=>'Yt::Request (gzip)'
      }).
    to_return(status: 200, body: File.open(api_channel_response).read, headers: {})
    stub_request(:get, "https://www.googleapis.com/youtube/v3/videos?id=&key=&part=snippet").
    with(
      headers: {
      'Content-Length'=>'0',
      'User-Agent'=>'Yt::Request (gzip)'
      }).
    to_return(status: 200, body: File.open(api_video_response).read, headers: {})
    campaign = Autopost::Campaign.create!(source_id: 1, provider_id: 1, key: "CHANNEL_ID", category_id: 1, owner_username: user.username )
    xml = File.open(push_xml).read
    
    Autopost::Youtube::PostVideo.post_video(xml)
    topic = Topic.last

    campaign.reload
    expect(campaign.channel_name).to eq "Merefield's Channel"
    expect(topic.user_id).to eq user.id
    expect(topic.title).to eq("Star Citizen Ship Showdown 2952")
  end
end