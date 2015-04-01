package "git" do
  action :install
end

package "libglib2.0-dev" do
  action :install
end

package "make" do
  action :install
end

git "/tmp/flashshitd" do
  repository "https://github.com/ian-llewellyn/FlashShitD.git"
  action :sync
end

execute "./configure && make && make install" do
  cwd "/tmp/flashshitd"
  not_if { ::File.exists?("/usr/local/bin/flashShitD")}
end

template "/etc/init.d/flashshitd" do
  source "flashshitd.init.erb"
  owner "root"
  group "root"
  mode "0744"
end

template "/usr/local/etc/flashShitD.policy" do
  source "flashShitD.policy.erb"
  owner "root"
  group "root"
  mode "0644"

  notifies :restart, "service[flashshitd]", :immediately
end

service "flashshitd" do
  action :enable
  supports :restart => true, :start => true, :stop => true
end

firewall_rule 'flashshitd' do
  port 843
  protocol :tcp
  action :allow
end