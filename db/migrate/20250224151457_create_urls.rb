class CreateUrls < ActiveRecord::Migration[7.1]
  def change
    create_table :urls do |t|
      t.string :long_url
      t.string :short_code

      t.timestamps
    end
  end
end
