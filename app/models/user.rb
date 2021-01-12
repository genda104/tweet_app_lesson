class User < ApplicationRecord
  # bcryptをインストールすると、has_secure_passwordというメソッドが使えるようになります。
  # パスワードを扱うUserモデルにhas_secure_passwordを追加します。
  # こうすることで、ユーザーを保存する際に自動的にパスワードを暗号化してくれます。
  has_secure_password
  # バリデーションは不正な投稿データを制限する機能でモデルで設定します。
  validates :name, {presence: true}   # 存在性
  validates :email, {presence: true, uniqueness: true}    # 存在性、一意性
  
  # インスタンスメソッド
  # Userモデル内にそのユーザーに紐付いたPostインスタンスを戻り値として返すpostsメソッドを定義します。
  def posts
    return Post.where(user_id: self.id)
  end
  
end