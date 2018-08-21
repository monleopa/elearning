class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password_digest
      t.string :avatar
      t.string :remember_digest
      t.boolean :admin, default:false
      t.string :activation_digest
      t.boolean :activated, default: false
      t.string :activated_at, :datetime
      t.string :reset_digest
      t.string :reset_sent_at, :datetime
      t.timestamps
    end
    add_index :users, :email, unique: true
  end
end
