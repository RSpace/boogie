class PagesController < ApplicationController
  before_action :authenticate_user!, :if => proc {|c| params[:login_required] }
end
