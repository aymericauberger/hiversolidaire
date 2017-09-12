class Admin::BaseController < ApplicationController
  before_action :authenticate_user!
  before_filter :check_admin

  def check_admin
    unless current_user.try(:admin?)
      raise
    end
  end
end
