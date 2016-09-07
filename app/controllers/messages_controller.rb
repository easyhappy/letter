class MessagesController < ApplicationController
  def create
    friend = User.find_by username: params[:username]
    status, message = current_user.send_message friend, params[:content]

    if status
      render json: {status: true, message: message}
    else
      render json: {status: false, error: message}
    end
  end

  def destroy

  end
end