def hubot_user
  node[:hubot][:user] ? node[:hubot][:user] : 'hubot'
end

def hubot_group
  node[:hubot][:group] ? node[:hubot][:group] : 'users'
end

def hubot_home
  node[:hubot][:home] ? node[:hubot][:home] : '/home/hubot'
end

def pill_file(bot_name)
  "/etc/bluepill/#{bot_name}.pill"
end

def config_file(bot_name)
  "/etc/hubot/#{bot_name}_config.rb"
end

def log_file(bot_name)
  "/var/log/hubot/#{bot_name}.log"
end