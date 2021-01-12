class Post < ApplicationRecord
  # バリデーションは不正な投稿データを制限する機能でモデルで設定します。
  validates :content, {presence: true, length: {maximum: 140}}    # 存在性、文字数
  validates :user_id, presence: true    # 存在性      {}がない書き方
  
  # インスタンスメソッド
  # Postモデル内にその投稿に紐付いたUserインスタンスを戻り値として返すuserメソッドを定義します。
  def user
    return User.find_by(id: self.user_id)
  end
  
end
