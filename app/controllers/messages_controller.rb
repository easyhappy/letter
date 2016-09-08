class MessagesController < ApplicationController
  def create
    friend = User.find_by username: params[:username]
    status, @message = current_user.send_message friend, params[:content]

    if status
      render :message
    else
      render json: {status: false, error: @message}
    end
  end

  def destroy
    message = current_user.messages.find_by(:id => params[:id])
    if message and message.destroy
      render json: {status: true, notice: '删除成功'}
    else
      render json: {status: false, error: '删除失败'}
    end
  end
end