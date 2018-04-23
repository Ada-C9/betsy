class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :current_or_guest_user

  before_action :current_or_guest_user

  # if user is logged in, return current_user, else return guest_user
 def current_or_guest_user
   find_user
   if @user
     if session[:guest_user_id] && session[:guest_user_id] != @user.id
       logging_in
       # reload guest_user to prevent caching problems before destruction
       guest_user(with_retry = false).try(:reload).try(:destroy)
       session[:guest_user_id] = nil
     end

     if @user.orders.find_by(status: "pending") == nil
       @order = Order.new(user_id: @user.id, status: "pending")
     end

     @user

   else
     guest_user
   end
 end

 # find guest_user object associated with the current session,
 # creating one as needed
 def guest_user(with_retry = true)
   # Cache the value the first time it's gotten.
   @cached_guest_user ||= User.find(session[:guest_user_id] ||= create_guest_user.id)
   @order = Order.new(user_id: @cached_guest_user.id, status: "pending")
    # @order.save
 rescue ActiveRecord::RecordNotFound # if session[:guest_user_id] invalid
    session[:guest_user_id] = nil
    guest_user if with_retry
 end

 def find_user
    @user = User.find_by(id: session[:user_id])
  end


 private

 # called (once) when the user logs in, insert any code your application needs
 # to hand off from guest_user to current_user.
 def logging_in

   ### Add anything we need to carry over from guest to logged in user
   ### (open order details)
   # For example:
   # guest_comments = guest_user.comments.all
   # guest_comments.each do |comment|
     # comment.user_id = current_user.id
     # comment.save!
   # end
 end

 def create_guest_user
   guest = User.new(:username => "guest", :email => "guest_#{Time.now.to_i}#{rand(100)}@example.com")
   guest.save!(:validate => true)
   session[:guest_user_id] = guest.id
   guest
 end




end
