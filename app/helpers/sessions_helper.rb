module SessionsHelper
  def all_user_names_for_select
    User.select(:username).order(:username).collect(&:username)
  end
end