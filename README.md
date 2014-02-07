# hubot cookbook

Installs and configures hubot for hipchat.

# Requirements

* vagrant
* bundler

# Usage

    git clone https://github.com/outofjungle/hubot-cookbook
    cd hubot-cookbook
    bundle install
    kitchen converge

# Attributes

User who will run the `hubot` process

    default['hubot']['user'] = 'hubot'
    default['hubot']['group'] = 'users'

`hubot` application will be unstalled in this directory

    default['hubot']['home'] = '/home/hubot'

`hipchat` credentials

    default['hipchat']['jabber_id'] = 'YOUR HIPCHAT JABBER ID'
    default['hipchat']['password'] = 'YOUR HIPCHAT PASSWORD'

# Todo

* Multiple adapter support

# Author

Author:: Venkat Venkataraju (<venkat.venkataraju@yahoo.com>)
