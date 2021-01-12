# ブラウザとコントローラを繋ぐ役割を担うのがルーティングです。
# ルーティングがURLを見て、適切なコントローラのアクションを呼び出します。
# get はデータベースを変更しないアクション用
# post はデータベースを変更するアクション用とsessionの値を変更するアクション用
Rails.application.routes.draw do
  post "likes/:post_id/create" => "likes#create"
  post "likes/:post_id/destroy" => "likes#destroy"

  post "users/:id/update" => "users#update"
  get "users/:id/edit" => "users#edit"
  post "users/create" => "users#create"
  # 新規登録のことは英語で「signup」という。そこでユーザー登録ページは「/signup」でアクセスできるようにします。
  get "signup" => "users#new"
  get "users/index" => "users#index"
  get "users/:id" => "users#show"
  post "login" => "users#login"
  post "logout" => "users#logout"
  get "login" => "users#login_form"
  get "users/:id/likes" => "users#likes"

  get "posts/index" => "posts#index"
  get "posts/new" => "posts#new"
  # ルーティングのURL部分に「:」を用いて「posts/:id」と書くと「/posts/◯◯」のような全てのURLが該当します。
  #「posts/:id」というルーティングは「posts/index」より下に書かなければいけません。
  # ルーティングは合致するURLを上から順に探します。そのため「posts/index」よりも上に書くと、
  #「localhost:3000/posts/index」というURLは「posts/:id」というルーティングに合致してしまいます。「posts/new」も同様。
  get "posts/:id" => "posts#show"
  # フォームの値を受け取る場合は「post」とする必要があります。（この「post」はPostモデルの「Post」とは関係ありません。）
  post "posts/create" => "posts#create"
  get "posts/:id/edit" => "posts#edit"
  post "posts/:id/update" => "posts#update"
  post "posts/:id/destroy" => "posts#destroy"

  # URLを変更しても、"home#top" の部分が変わらない限りhomeコントローラのtopアクションに対応する
  # ビューファイル（= top.html.erb）の内容がブラウザに表示されます。
  # 「localhost:3000」 (後ろに/○○がないURL) に対応するルーティングは、「get "/" => "コントローラ名#アクション名"」というように、URLに"/"を指定します。
  get "/" => "home#top"               # root 'home#top' -------「root 'コントローラ名#アクション名'」の文法でもルートURLを設定出来ます。
  get "about" => "home#about"         # get 'about', to: 'home#about' の文法でも可。
end