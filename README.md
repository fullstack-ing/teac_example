# TeacExample (Twitch Elixir API Client)

## NOTE:
* this is a work in progress.
* this is currently inside a temp project until we have a better inital release.

TeacExample is an elixir client for the Twitch API.

The goal of this project is to use REST api and Alos the Websocket Endpoint

## Roadmap of API Endpoints:

### Analytics
- [ ] Extensions.get()
- [ ] Game.get()

### Bits
- [ ] Cheermotes.get()
- [ ] Extensions.get()
- [ ] Extensions.put()
- [ ] Leaderboard.get()

### ChannelPoints
- [ ] CustomRewards.get()
- [ ] CustomRewards.post()
- [ ] CustomRewards.patch()
- [ ] CustomRewards.delete()
- [ ] Redemptions.get()
- [ ] Redemptions.patch()

### Channels
- [ ] get()
- [ ] patch()
- [ ] Ads.get()
- [ ] Ads.Schedule.Snooze.post()
- [ ] Commercial.post()
- [ ] Editors.get()
- [ ] Followed.get()
- [ ] Followers.get()
- [ ] Vips.get()
- [ ] Vips.delete()

### Charity
- [ ] Campaigns.get()
- [ ] Donations.get()

### Chat
- [x] Announcements.post()
- [x] Badges.get()
- [x] Badges.Global.get()
- [ ] Chatters.get()
- [ ] Color.get()
- [ ] Color.put()
- [x] Emotes.get()
- [x] Emotes.Global.get()
- [ ] Emotes.Set.get()
- [ ] Emotes.User.get()
- [x] Messages.post()
- [ ] Settings.get()
- [ ] Settings.patch()
- [ ] Shoutouts.post()

### Clips
- [ ] get()
- [ ] post()

### ContentClassificationLabels
- [ ] get()

### Entitlements
- [ ] Drops.get()
- [ ] Drops.patch()

### EventSub
- [ ] Conduits.get()
- [ ] Conduits.post()
- [ ] Conduits.patch()
- [ ] Conduits.delete()
- [ ] Conduits.Shards.get()
- [ ] Conduits.Shards.patch()
- [ ] Subscriptions.get()
- [ ] Subscriptions.post()
- [ ] Subscriptions.delete()

### Extensions do
- [ ] get()
- [ ] Chat.post()
- [ ] Configurations.get()
- [ ] Configurations.put()
- [ ] Live.get()
- [ ] Jwt.Secrets.get()
- [ ] PubSub.post()
- [ ] Released.get()
- [ ] RequiredConfiguration.put()
- [ ] Transactions.get()

### Games do
- [ ] get()
- [ ] Top.get()

### Goals
- [ ] get()

### GuestStar
- [ ] ChannelCettings.get()
- [ ] ChannelCettings.put()
- [ ] Invites.get()
- [ ] Invites.post()
- [ ] Invites.delete()
- [ ] Session.get()
- [ ] Session.post()
- [ ] Session.delete()
- [ ] Slot.get()
- [ ] Slot.post()
- [ ] Slot.delete()
- [ ] SlotSettings.patch()

### Hypetrain
- [ ] get()

### Moderation
- [ ] Automod.Settings.get()
- [ ] Automod.Settings.put()
- [ ] Bans.post()
- [ ] Bands.delete()
- [ ] Banned.get()
- [ ] BlockedTerms.get()
- [ ] BlockedTerms.post()
- [ ] BlockedTerms.delete()
- [ ] Channels.get()
- [ ] Chat.delete()
- [ ] Snforcements.Status.post()
- [ ] Moderators.get()
- [ ] Moderators.post()
- [ ] Moderators.delete()
- [ ] ShieldMode.get()
- [ ] ShieldMode.put()
- [ ] Warnings.post()
- [ ] UnbanRequests.get()
- [ ] UnbanRequests.patch()

### Polls
- [ ] get()
- [ ] post()
- [ ] patch()

### Predictions
- [ ] get()
- [ ] post()
- [ ] patch()

### Raids
- [ ] post()
- [ ] delete()

### Schedule
- [ ] get()
- [ ] delete()
- [ ] ICalendar.get()
- [ ] Segment.post()
- [ ] Segment.patch()
- [ ] Settings.patch()

### Search
- [ ] Categories.get()
- [ ] Channels.get()

### SharedChat
- [ ] get()

### Streams
- [ ] get()
- [ ] Followed.get()
- [ ] Markers.get()
- [ ] Markers.post()
- [ ] Tags.get()

### Subscriptions
- [ ] get()
- [ ] User.get()

### Tags
- [ ] get()

### Teams
- [ ] get()
- [ ] Channel.get()

### Users
- [x] get()
- [x] put()
- [ ] Blocks.get()
- [ ] Blocks.put()
- [ ] Blocks.delete()
- [ ] Extensions.get()
- [ ] Extensions.put()
- [ ] Extensions.List.get()

### Videos
- [ ] get()
- [ ] delete()

### Whipsers
- [ ] get()

To start your Phoenix server:

  * Run `mix setup` to install and setup dependencies
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix
