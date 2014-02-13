#
# Cookbook Name:: hubot
# Recipe:: default
#

include_recipe 'bluepill'

user hubot_user do
  supports :manage_home => true
  gid hubot_group
  home hubot_home
  shell '/bin/sh'
end

remote_file '/tmp/epel-release-6-8.noarch.rpm' do
  source 'http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm'
  mode 00644
end

rpm_package '/tmp/epel-release-6-8.noarch.rpm'
package 'nodejs'
package 'npm'
package 'redis'
package 'expat-devel'
package 'libicu-devel'

service 'redis' do
  action [:start, :enable]
end

%w(inherits coffee-script hubot).each do |pkg|
  execute "installing npm package #{pkg}" do
    command "npm install -global #{pkg}"
    not_if "npm list -global -parseable #{pkg}"
  end
end

execute 'install hubot' do
  command 'hubot --create .'
  cwd hubot_home
  user hubot_user
  group hubot_group
  not_if { File.exist?("#{hubot_home}/bin/hubot") }
end

execute "installing hubot dependencies for #{hubot_user}" do
  command "sudo -H -u #{hubot_user} /usr/bin/npm install"
  cwd "#{hubot_home}"
end

execute "installing hipchat adapter for #{hubot_user}" do
  command "sudo -H -u #{hubot_user} /usr/bin/npm install --save hubot-hipchat"
  not_if 'npm list -parseable hubot-hipchat'
  cwd "#{hubot_home}"
end

execute 'add the gtalk adapter' do
  command "sudo -H -u #{hubot_user} /usr/bin/npm install --save hubot-gtalk-gluck"
  cwd "#{hubot_home}"
end

directory '/etc/hubot' do
  mode 00600
  recursive true
end

directory '/var/run/hubot' do
  user hubot_user
  group hubot_group
  mode 00755
  recursive true
end

directory '/var/log/hubot' do
  user hubot_user
  group hubot_group
  mode 00755
  recursive true
end

hubot_hipchat 'secretsauce' do
  jabber_id node[:hipchat][:jabber_id]
  password node[:hipchat][:password]
end

hubot_gtalk 'secretsauce' do
  username node[:gtalk][:username]
  password node[:gtalk][:password]
end
