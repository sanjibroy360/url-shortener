class AddIndexToUrlShortCode < ActiveRecord::Migration[7.1]
  def change
    add_index :urls, :short_code, unique: true
  end
end
