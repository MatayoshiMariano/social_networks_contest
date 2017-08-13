class CreateProviders < ActiveRecord::Migration[5.1]
  def change
    create_table :providers do |t|
      t.integer :type
      t.text :access_token
      t.string :uid
      t.references :user
      t.time :expires_at

      t.timestamps
    end
  end
end
