# frozen_string_literal: true

require 'rails/generators'

module EIVO
  class InstallGenerator < Rails::Generators::Base
    include Rails::Generators::Migration

    source_root File.expand_path('templates', __dir__)

    def self.namespace(name = nil)
      @namespace ||= super.sub('e_i_v_o', 'eivo')
    end

    # Implement the required interface for Rails::Generators::Migration.
    def self.next_migration_number(dirname)
      next_migration_number = current_migration_number(dirname) + 1
      ActiveRecord::Migration.next_migration_number(next_migration_number)
    end

    def create_initializer_file
      @application = Rails.application.class.module_parent_name

      remove_dir 'config/environments'

      copy_file 'Gemfile'
      copy_file 'Procfile'
      copy_file '.env.example'
      copy_file '.ruby-version'
      copy_file '.rubocop.yml'

      create_restart_files

      template 'config/application.rb'
      copy_file 'config/puma.rb'
      copy_file 'config/database.example.yml'
      template 'config/database.local.yml', 'config/database.yml', skip: true

      copy_file 'app/controllers/application_controller.rb'

      migration_template 'db/migrate/enable_pgcrypto_extension.rb', 'db/migrate/enable_pgcrypto_extension.rb', skip: true
      migration_template 'db/migrate/enable_pg_stat_statements_extension.rb', 'db/migrate/enable_pg_stat_statements_extension.rb', skip: true
      migration_template 'db/migrate/enable_btree_gin_extension.rb', 'db/migrate/enable_btree_gin_extension.rb', skip: true
      migration_template 'db/migrate/enable_unaccent_extension.rb', 'db/migrate/enable_unaccent_extension.rb', skip: true

      route "mount EIVO::Engine => '/'"
    end

    def create_restart_files
      restart_code = <<~'EIVO_COMMAND'
        ### EIVO begin ###

        bundle exec pumactl -F config/puma.rb restart

        ### EIVO end ###
      EIVO_COMMAND

      stop_code = <<~'EIVO_COMMAND'
        ### EIVO begin ###

        bundle exec pumactl -F config/puma.rb stop

        ### EIVO end ###
      EIVO_COMMAND

      header_production = <<~'EIVO_COMMAND'
        #!/usr/bin/env bash
        export RACK_ENV="production"
        export RAILS_ENV="production"
        export RAILS_DAEMONIZE="true"

      EIVO_COMMAND

      header_staging = <<~'EIVO_COMMAND'
        #!/usr/bin/env bash
        export RACK_ENV="staging"
        export RAILS_ENV="staging"
        export RAILS_DAEMONIZE="true"

      EIVO_COMMAND

      create_file 'restart_production.sh', header_production, skip: true
      create_file 'stop_production.sh', header_production, skip: true
      create_file 'restart_staging.sh', header_staging, skip: true
      create_file 'stop_staging.sh', header_staging, skip: true

      # Remove old code if present
      regexp = /\n### EIVO begin ###.*### EIVO end ###/m
      gsub_file 'restart_production.sh', regexp, ''
      gsub_file 'restart_staging.sh', regexp, ''
      gsub_file 'stop_production.sh', regexp, ''
      gsub_file 'stop_staging.sh', regexp, ''

      # Inject new code
      inject_into_file 'restart_production.sh', restart_code, after: header_production
      inject_into_file 'stop_production.sh', stop_code, after: header_production
      inject_into_file 'restart_staging.sh', restart_code, after: header_staging
      inject_into_file 'stop_staging.sh', stop_code, after: header_staging

      chmod 'restart_production.sh', 0o755
      chmod 'stop_production.sh', 0o755
      chmod 'restart_staging.sh', 0o755
      chmod 'stop_staging.sh', 0o755
    end
  end
end
