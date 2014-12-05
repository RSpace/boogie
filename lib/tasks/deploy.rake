task :deploy do
  puts `git push heroku master && heroku run rake db:migrate`
end