# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# テスト等で使うためデータベースのデータをまとめて作成する。

User.create!(
  name: "管理者",
  email: "admin@email.com",
  image_name: "default_user.jpg",
  password: "password",
  )

4.times do |n|
name  = "サンプルユーザー#{n+2}"
email = "sample#{n+2}@email.com"
image_name = "default_user.jpg"
password = "password"
User.create!(
    name: name,
    email: email,
    image_name: image_name,
    password: password,
    )
end

5.times do |n|
content  = "今日のつぶやき#{n+1}"
user_id = n+1
Post.create!(
    content: content,
    user_id: user_id,
    )
end