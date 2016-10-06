class AddCatPictures < ActiveRecord::Migration
  def change
    add_column :cats, :picture, :text, default: 'https://i.ytimg.com/vi/mW3S0u8bj58/maxresdefault.jpg'
  end
end
