# config valid only for current version of Capistrano
lock '3.4.1'

set :application, 'rails'

set :application_user, 'tim'

# リポジトリ設定
set :repo_url, 'https://ruguz@github.com/ruguz/rails_sample.git'

# シンボリックリンクにするディレクトリ
set :linked_dirs, fetch(:linked_dirs, []).push('log')

# デプロイ先でのソースのバージョンの保持数
set :keep_releases, 3

# コマンド実行時にsudoをつけるか
set :use_sudo, false

set :group, "tim"
set :deploy_user, 'tim'

# デプロイするディレクトリパス
set :deploy_to, "/home/#{fetch :application_user}/apps/#{fetch :application}"

# ブランチ名
set :branch, ENV["REVISION"] || ENV["BRANCH_NAME"] || 'master'

# rbenv
set :rbenv_type, :user
set :rbenv_ruby, '2.2.4'
