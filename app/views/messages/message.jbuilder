json.status true
json.is_self true
json.message do
  json.(@message, :id, :user_id, :friend_id, :content)
  json.name @message.user.name
  json.friend_name @message.friend.name
  json.created_at timeago @message.created_at
end