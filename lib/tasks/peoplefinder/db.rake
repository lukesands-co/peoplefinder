namespace :peoplefinder do
  namespace :db do

    desc 'remove stale profiles'
    task :remove_stale_profiles => :environment do
      puts '...removing stale profiles'
      Person.where("last_login_at < ? and super_admin = FALSE", 6.months.ago).destroy_all
    end

    desc 'reset subscribed memberships'
    task :reset_subscribed_memberships => :environment do
      puts '...resetting subscribed memberships'
      Membership.update_all subscribed: false
    end

    desc 'drop all tables'
    task :clear => :environment do
      conn = ActiveRecord::Base.connection
      tables = conn.tables
      tables.each do |table|
        puts "...dropping #{table}"
        conn.drop_table(table, force: :cascade)
      end
    end

    desc 'reset all column information'
    task :reset_column_information => :environment do
      conn = ActiveRecord::Base.connection
      tables = conn.tables
      tables.each do |table|
        next if %w{ schema_migrations delayed_jobs }.include? table
        table.classify.constantize.reset_column_information
      end
    end

    desc 'drop tables, migrate, seed and populate with demonstration data for development purposes'
    task :reload => [:environment, :clear] do
      puts '...migrating'
      Rake::Task['db:migrate'].invoke

      # col reset required due to schema changes from migrations not being reflected in models
      puts '...resetting column information'
      Rake::Task['peoplefinder:db:reset_column_information'].invoke

      puts '...seeding'
      Rake::Task['db:seed'].invoke

      puts '...creating demonstration data'
      Rake::Task['peoplefinder:data:demo'].invoke
    end

  end
end
