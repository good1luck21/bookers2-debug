module MessagesHelper
  def display_user(conversation)
    if conversation.recipient_id == current_user.id
      conversation.sender.name
    else
      conversation.recipient.name
    end
  end
end
