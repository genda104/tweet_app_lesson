# カラムを追加する場合はadd_columnを用います。
# 「add_column :テーブル名, :カラム名, :データ型」
class AddImageNameToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :image_name, :string
  end
end
