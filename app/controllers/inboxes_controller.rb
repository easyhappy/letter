class InboxesController < ApplicationController
  def index
  end

  def show
    inbox = current_user.inboxes.find(params[:id])

    @messages = Message.inbox_messages(inbox).paginate(:page => params[:page] || 1, :per_page => params[:per] || 10)
  end
end