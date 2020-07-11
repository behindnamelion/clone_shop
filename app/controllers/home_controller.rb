class HomeController < ApplicationController
  before_action :authenticate_user!, only: [:mypage]

  def mypage
    @user = current_user
  end
  
  def index
  end
end
