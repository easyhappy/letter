json.status true
json.is_self true
json.message do
  json.(@message, :id, :user_id, :friend_id, :content)
  json.username @message.user.username
  json.friend_username @message.friend.username
  json.created_at timeago @message.created_at
end