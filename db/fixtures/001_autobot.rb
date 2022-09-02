autopost_username = 'autopost'
user = User.find_by(id: -3)

if !user
  suggested_username = UserNameSuggester.suggest(autopost_username)

  UserEmail.seed do |ue|
    ue.id = -3
    ue.email = "autopost_email"
    ue.primary = true
    ue.user_id = -3
  end

  User.seed do |u|
    u.id = -3
    u.name = autopost_username
    u.username = suggested_username
    u.username_lower = suggested_username.downcase
    u.password = SecureRandom.hex
    u.active = true
    u.approved = true
    u.trust_level = TrustLevel[4]
  end

  # # TODO Design a unique bot icon
  # if !Rails.env.test?
  #   begin
  #     UserAvatar.import_url_for_user(
  #       "",
  #       User.find(-3),
  #       override_gravatar: true
  #     )
  #   rescue
  #     # In case the avatar can't be downloaded, don't fail seed
  #   end
  # end
end

bot = User.find(-3)

bot.user_option.update!(
  email_messages_level: 0,
  email_level: 2
)

if !bot.user_profile.bio_raw
  bot.user_profile.update!(
    bio_raw: I18n.t('autopost.bio', site_title: SiteSetting.title, autopost_username: bot.username)
  )
end

Group.user_trust_level_change!(-3, TrustLevel[4])
