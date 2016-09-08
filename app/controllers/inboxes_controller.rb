class InboxesController < ApplicationController
  def index
    @inboxes = current_user.inboxes.paginate(:page => params[:page] || 1, :per_page => params[:per] || 10)
  end

  def show
    inbox = current_user.inboxes.find(params[:id])

    @messages = Message.inbox_messages(inbox).paginate(:page => params[:page] || 1, :per_page => params[:per] || 10)
  end

  def destroy
    inbox = current_user.inboxes.find(params[:id])
    if inbox and inbox.destroy
    end
    redirect_to request.referer
  end
end