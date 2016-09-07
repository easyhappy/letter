class CreateInboxes < ActiveRecord::Migration[5.0]
  def change
    create_table :inboxes do |t|
      t.references :user
      t.references :friend
      t.integer    :unread_count, default: 0
      t.timestamps
    end
  end
end
