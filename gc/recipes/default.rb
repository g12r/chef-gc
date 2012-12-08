include_recipe "apt"

target_user = "vagrant"
target_ruby = "1.9.3-p327"

execute "apt_update" do
  command "apt-get update -y"
  action :run
end

# this wants to run grub, which fucks all kinds of stuff up.
# execute "apt_upgrade" do
#   command "apt-get upgrade -y"
#   action :run
# end

package "curl" do
  action :install
end

execute "install_oh-my-zsh" do
	command "git clone https://github.com/robbyrussell/oh-my-zsh.git /home/#{target_user}/.oh-my-zsh"
	action :run
end

execute "set_zshrc" do
	command "cp /home/#{target_user}/.oh-my-zsh/templates/zshrc.zsh-template /home/#{target_user}/.zshrc"
	action :run
end

execute "change_shell_to_zsh" do
	command "chsh -s /bin/zsh #{target_user}"
	action :run
end

execute "get_dotfiles" do
	command "mkdir /home/#{target_user}/.dotfiles"
	command "git clone https://github.com/g12r/dotfiles.git /home/#{target_user}/.dotfiles"
	action :run
end

execute "link_dotfile_gc_zsh_theme" do
	command "ln -f /home/#{target_user}/.dotfiles/gc.zsh-theme /home/#{target_user}/.oh-my-zsh/themes/gc.zsh-theme"
	action :run
end

execute "link_dotfile_zshrc" do
	command "ln -f /home/#{target_user}/.dotfiles/.zshrc /home/#{target_user}/.zshrc"
	action :run
end

execute "add_rbenv_paths_to_zsrhc" do
	command "echo 'export PATH=\"/home/#{target_user}/.rbenv/bin/:$PATH\"' >> /home/#{target_user}/.zshrc"
	action :run
end

execute "add_rbenv_init_to_zsrhc" do
	command "echo 'eval \"$(rbenv init -)\"' >> /home/#{target_user}/.zshrc"
	action :run
end

rbenv_ruby target_ruby do
	user target_user
  action :install
end

rbenv_global target_ruby do
  user target_user
end

rbenv_gem "rails" do
	user target_user
  rbenv_version target_ruby
  action :install
end

rbenv_gem "libv8" do
	user target_user
  rbenv_version target_ruby
  action :install
end

rbenv_gem "execjs" do
	user target_user
  rbenv_version target_ruby
  action :install
end

rbenv_gem "therubyracer" do
	user target_user
  rbenv_version target_ruby
  action :install
end

package "libpq-dev" do # for pg
  action :install
end

rbenv_gem "pg" do
	user target_user
	rbenv_version target_ruby
  action :install
end

# execute "rbenv_rehash" do
# 	user #{target_user}
# 	command "rbenv rehash"
# 	action :run
# end

# rbenv_rehash do
# 	name "rails"
# 	user "vagrant"
# end