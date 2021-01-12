# マイグレーションファイルは、データベースに変更を指示するためのファイルです。
# Railsでは、データベースに反映されていないマイグレーションファイルが存在する状態で、
# どこかのページにアクセスするとマイグレーションエラーが発生してしまいます。
# そのため、マイグレーションファイルを作成した場合は必ず「rails db:migrate」を実行する必要があります。
class CreatePosts < ActiveRecord::Migration[5.0]
  def change
    create_table :posts do |t|
      t.text :content

      t.timestamps
    end
  end
end
