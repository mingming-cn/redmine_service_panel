# Redmine Service Panel


# Installation

```
cd $REDMINE_ROOT
git clone -b stable https://github.com/mingming-cn/redmine_service_panel.git plugins/redmine_service_panel
bundle config set --local without 'development test'
bundle install
bundle exec rake redmine:plugins:migrate RAILS_ENV=production
```

# Update

Update redmine_service_panel plugin.

```
cd $REDMINE_ROOT/plugins/redmine_service_panel
git pull
cd ../..
bundle install
bundle exec rake redmine:plugins:migrate RAILS_ENV=production
```
