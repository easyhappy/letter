class CreateMessages < ActiveRecord::Migration[5.0]
  def change
    create_table :messages do |t|
      t.references :user
      t.references :friend
      t.references :inbox
      t.references :friend_inbox
      t.text       :content
      t.datetime   :deleted_at
      t.timestamps
    end
  end
end
