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
    not_if "npm list -global -parseable #{pkg} | grep #{pkg}"
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
  command "sudo -H -u #{hubot_user} /usr/bin/npm install --prefix #{hubot_home}"
  cwd "#{hubot_home}"
end

execute "installing hipchat adapter for #{hubot_user}" do
  command "sudo -H -u #{hubot_user} /usr/bin/npm install --prefix #{hubot_home} --save hubot-hipchat"
  not_if "/usr/bin/npm list --parseable --prefix #{hubot_home} hubot-hipchat | grep hubot-hipchat"
end

execute 'add the gtalk adapter' do
  command "sudo -H -u #{hubot_user} /usr/bin/npm install --prefix #{hubot_home} --save hubot-gtalk-gluck"
  not_if "/usr/bin/npm list --prefix #{hubot_home} --parseable hubot-gtalk-gluck | grep hubot-gtalk-gluck"
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
