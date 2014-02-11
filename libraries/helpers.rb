def hubot_user
  node['hubot']['user'] ? node['hubot']['user'] : 'hubot'
end

def hubot_group
  node['hubot']['group'] ? node['hubot']['group'] : 'users'
end

def hubot_home
  node['hubot']['home'] ? node['hubot']['home'] : '/home/hubot'
end