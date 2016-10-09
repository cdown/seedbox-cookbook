include_recipe 'openssh'
include_recipe 'rtorrent'

user 'Main user' do
  username lazy { node['seedbox']['user'] }
  home lazy { node['seedbox']['user_path'] }
  manage_home true
end

ssh_authorize_key 'Main user' do
  user node['seedbox']['user']
  key node['seedbox']['user_ssh_pubkey']
end

package 'mosh' do
  action :upgrade
end
