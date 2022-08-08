class CreateMessages < ActiveRecord::Migration[6.1]
  def change
    create_table :messages do |t|
      t.text :body
      t.integer :conversation_id, index: true
      t.integer :user_id, index: true

      t.timestamps
    end
  end
end
