class UsersController < ApplicationController
  before_action :current_or_guest_user
end
