class ChatsController < ApplicationController
  before_action :hide_footer, only: [:show]

  def create
    @chat = Chat.new(title: "New Chat")
    @chat.user = current_user
    if params[:trip_id].present?
      @trip = Trip.find_by(id: params[:trip_id])
      @chat.trip = @trip if @trip
    end
    # TODO: linker le trip si params trip_id

    if @chat.save
      redirect_to chat_path(@chat)
    else
      render "chats/index"
    end
  end

  def show
    @chat = Chat.find(params[:id])
    @trip = @chat.trip
    @messages = @chat.messages
    @message = Message.new
  end

  def index
    @chats = current_user&.chats
  end

private

  def hide_footer
    @hide_footer = true
  end
end
