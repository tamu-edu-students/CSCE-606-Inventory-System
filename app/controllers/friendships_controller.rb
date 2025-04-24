class FriendshipsController < ApplicationController
  before_action :authenticate_user!
  
  def index
    @friends = current_user.all_friends
  end
  
  def create
    friend = User.find_by(email: params[:email])
    
    if friend
      friendship = current_user.friendships.build(friend: friend)
      
      if friendship.save
        flash[:notice] = "Successfully added #{friend.email} as a friend"
      else
        flash[:alert] = friendship.errors.full_messages.join(", ")
      end
    else
      #flash[:alert] = "User not found" Change by rafael
    end
    
    redirect_to friendships_path
  end
  
  def destroy
    friendship = current_user.friendships.find(params[:id])
    friend_email = friendship.friend.email
    
    if friendship.destroy
      flash[:notice] = "Removed #{friend_email} from friends"
    else
      #flash[:alert] = "Failed to remove friend" Change by rafael
    end
    
    redirect_to friendships_path
  end
end 