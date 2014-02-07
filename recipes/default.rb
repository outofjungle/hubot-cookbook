#
# Cookbook Name:: hubot
# Recipe:: default
#

include_recipe 'bluepill'

user node['hubot']['user'] do
  supports :manage_home => true
  gid node['hubot']['group']
  home node['hubot']['home']
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
  execute "npm install -g #{pkg}"
end

execute 'install hubot' do
  command 'hubot --create .'
  cwd node['hubot']['home']
  user node['hubot']['user']
  group node['hubot']['group']
  not_if { File.exist?("#{node['hubot']['home']}/bin/hubot") }
end

execute 'npm install in hubot dir' do
  command "sudo -H -u #{node['hubot']['user']} /usr/bin/npm install"
  cwd "#{node['hubot']['home']}"
end

execute 'npm install in hubot hipchat adapter' do
  command "sudo -H -u #{node['hubot']['user']} /usr/bin/npm install --save hubot-hipchat"
  cwd "#{node['hubot']['home']}"
end

directory '/etc/hubot' do
  mode 00600
  recursive true
end

template '/etc/hubot/config.rb' do
  source 'config.rb.erb'
  mode 00600
end

directory '/var/run/hubot' do
  user node['hubot']['user']
  group node['hubot']['group']
  mode 00755
  recursive true
end

file '/var/log/hubot/hubot.log' do
  user node['hubot']['user']
  group node['hubot']['group']
  mode 00644
end

template '/etc/bluepill/hubot.pill' do
  source 'hubot.pill.erb'
  mode 00644
end

bluepill_service 'hubot' do
  action [:enable, :load, :start]
end
