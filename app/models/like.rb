class Like < ApplicationRecord
  # バリデーションは不正な投稿データを制限する機能でモデルで設定します。
  validates :user_id, {presence: true}      # 存在性
  validates :post_id, {presence: true}      # 存在性
end
