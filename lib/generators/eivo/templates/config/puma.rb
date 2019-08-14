# frozen_string_literal: true

workers ENV.fetch('WEB_CONCURRENCY') { 0 }
threads_count = ENV.fetch('RAILS_MAX_THREADS') { 5 }
threads threads_count, threads_count

environment ENV.fetch('RAILS_ENV') { 'development' }

if %w[production staging].include?(ENV['RAILS_ENV'])
  bind 'unix://tmp/sockets/puma.sock'
  pidfile 'tmp/pids/puma.pid'
  state_path 'tmp/pids/puma.state'
  daemonize true
else
  port ENV.fetch('PORT') { 3000 }
end

before_fork do
  ActiveRecord::Base.connection.disconnect!
end

on_worker_boot do
  ActiveSupport.on_load(:active_record) do
    ActiveRecord::Base.establish_connection
  end
end

preload_app!

plugin :tmp_restart
