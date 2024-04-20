class CreateImageGenerates < ActiveRecord::Migration[7.0]
  def change
    create_table :image_generates do |t|
      t.text :word_chain, null: false
      t.text :prompt, null: false
      t.integer :http_status, null: false
      t.string :generate_model, null: false
      t.references :user, null: false, foreign_key: true
      t.timestamps
    end
  end
end
