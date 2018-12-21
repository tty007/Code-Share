class UsersController < ApplicationController
  before_action :authenticate, only: %i(show)

  def index
  end

  def show
  end
end
