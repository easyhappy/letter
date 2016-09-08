class InboxesController < ApplicationController
  def index
    @current_page = "inbox_list"

    @inboxes = current_user.inboxes.paginate(:page => params[:page] || 1, :per_page => params[:per] || 10)
  end

  def show
    @current_page = "inbox_show"

    @inbox = current_user.inboxes.find(params[:id])
    @inbox.reset_unread_count

    @messages = Message.inbox_messages(@inbox).includes(:user, :friend).paginate(:page => params[:page] || 1, :per_page => params[:per] || 10)
  end

  def destroy
    inbox = current_user.inboxes.find(params[:id])
    inbox.destroy

    redirect_to request.referer
  end
end