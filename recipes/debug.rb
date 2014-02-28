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
