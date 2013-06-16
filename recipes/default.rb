include_recipe "apt"

target_user = "vagrant"
ruby_193 = "1.9.3-p429"
ruby_200 = "2.0.0-p0"
# works was 193, keep as is for now -- should work in a future rails/ruby combo
default_ruby = ruby_193
# default_ruby = ruby_200

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

# if we need to diverge from dotfiles, we could modify export RBENV_VERSION to what we need

execute "update_gem" do
	command "gem update --system"
	action :run
end

rbenv_ruby ruby_193 do
	user target_user
  action :install
end

rbenv_ruby ruby_200 do
	user target_user
  action :install
end

rbenv_global default_ruby do
  user target_user
end

# shell doesn't work, not sure how necessary this is
# execute "rbenv_shell" do
# 	user target_user
# 	command "rbenv shell #{default_ruby}"
# 	action :run
# end

rbenv_gem "rails" do
	user target_user
  rbenv_version default_ruby
  # working
  # version "3.2.12"
  action :install
end

package "libpq-dev" do # for pg
  action :install
end

rbenv_gem "pg" do
	user target_user
	rbenv_version default_ruby
  action :install
end

execute "apt_update" do
  command "apt-get update -y"
  action :run
end

execute "apt_upgrade" do
  command "apt-get upgrade -y"
  action :run
end

