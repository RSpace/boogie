task :deploy do
  puts `git push heroku master`
  puts `heroku run rake db:migrate`
end