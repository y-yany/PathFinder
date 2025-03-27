class HomeController < ApplicationController
  skip_before_action :authenticate_user!

  def index; end

  def privacy_policy; end

  def terms_of_use; end
end
