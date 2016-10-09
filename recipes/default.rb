include_recipe 'openssh'
include_recipe 'rtorrent'
include_recipe 'sudo'
include_recipe 'unattended-upgrades'

%w(mosh zsh).each do |pkg|
  package pkg do
    action :upgrade
  end
end

user 'Main user' do
  username lazy { node['seedbox']['user'] }
  home lazy { node['seedbox']['user_path'] }
  manage_home true
  shell '/bin/zsh'
end

group 'sudo' do
  action :create
  members lazy { [node['seedbox']['user']] }
  append true
end

ssh_authorize_key 'Main user' do
  user node['seedbox']['user']
  key node['seedbox']['user_ssh_pubkey']
end

sudo 'Allow any sudoer to go to rtorrent without password' do
  user '%sudo'
  runas lazy { node['rtorrent']['user'] }
  nopasswd true
  commands ['ALL']
end
