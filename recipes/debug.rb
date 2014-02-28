#
# Cookbook Name:: hubot
# Recipe:: debug
#

hubot_hipchat 'secretsauce' do
  env ({
    'HUBOT_HIPCHAT_JID' => node[:hipchat][:jabber_id],
    'HUBOT_HIPCHAT_PASSWORD' => node[:hipchat][:password]
  })
end

hubot_gtalk 'secretsauce' do
  env ({
      'HUBOT_GTALK_USERNAME' => node[:gtalk][:username],
      'HUBOT_GTALK_PASSWORD' => node[:gtalk][:password]
  })
end

hubot_irc 'secretsauce' do
  env ({
      'HUBOT_IRC_SERVER' => node[:irc][:server],
      'HUBOT_IRC_ROOMS' => node[:irc][:rooms],
      'HUBOT_IRC_NICK' => node[:irc][:nick],
      'HUBOT_IRC_UNFLOOD' => node[:irc][:unflood],
      'HUBOT_IRC_DEBUG' => "true"
  })
end
