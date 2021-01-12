class PostsController < ApplicationController
  before_action :authenticate_user                                          #ApplicationControllerで定義
  before_action :ensure_correct_user, {only: [:edit, :update, :destroy]}
  
  # 投稿一覧
  # 「Post.all」では、テーブルにある全てのデータが「配列」で取得できる
  # orderメソッドを用いることで、投稿一覧を並び替えることができます。
  # order(カラム名: 並び替えの順序）のように使います。並び替えの順序には、昇順（:asc）と降順（:desc）のどちらかを指定できます。
  def index
    @posts = Post.all.order(created_at: :desc)
  end
  
  # 投稿詳細
  def show
    # コントローラのアクション内では、ルーティングで設定したURLの「:id」の値を取得することができます。
    # その値はparamsという変数にハッシュとして入っています。params[:id]とすることで、その値を取得することができます。
    @post = Post.find_by(id: params[:id])     #「モデル名.find_by(カラム名: 値)」
    @user = @post.user    # Postモデル内にその投稿に紐付いたUserインスタンスを戻り値として返すuserメソッドを定義してある。
    # likesテーブルからデータの件数を取得するには、countメソッドを用います。
    @likes_count = Like.where(post_id: @post.id).count
  end
  
  # 新規投稿ページ
  def new
    # new.html.erbで変数@postを使用するようにしますが、本来、newアクションを経由して表示されるビューです。
    # @postにPost.newを代入しておけば、うまく動くようになります。
    # createアクションからrenderで来た時new.html.erbに対応したnewアクションに@postが定義されていないとエラーになります。
    @post = Post.new
  end
  
  # 入力された新規投稿データをデータベースに保存
  # createアクションに対応するビューがない代わりに「リダイレクト」という方法を使い他のURLに転送します。
  # name属性を指定したフォームに入力されたデータは、コントローラーのアクション内で受け取ることが可能になります。
  # フォームのデータは、変数paramsで受け取ります。paramsはname属性に設定した文字列をキーとしたハッシュになっています。
  # 実際に保存する手順としては、Postインスタンスを作成する際にparams[:content]を用います。そのPostインスタンスを保存することで完了です。
  def create
    @post = Post.new(
      content: params[:content],
      user_id: @current_user.id
    )
    if @post.save
      # ページ上に1度だけ表示されるメッセージをフラッシュといいます。
      # フラッシュが表示された後、ページを更新したり、別のページに移動したりすると、フラッシュは表示されなくなります。
      # Railsではフラッシュを表示するために、特殊な変数flashが用意されています。
      flash[:notice] = "投稿を作成しました"
      redirect_to("/posts/index")
    else
      # renderメソッドを用いることで、別のアクションを経由せずに、直接ビューを表示することができます。
      # render("フォルダ名/ファイル名")のように表示したいビューを指定します。
      # renderメソッドを使うと、redirect_toメソッドを使った場合と違い、そのアクション内で定義した@変数をビューでそのまま使うことができます。
      render("posts/new")
    end
  end
  
  # 投稿編集ページ
  def edit
    @post = Post.find_by(id: params[:id])
  end
  
  # 入力された投稿編集データをデータベースに保存
  # HTMLの<textarea>タグにname属性を指定し、フォームの入力内容が変数paramsに代入されてupdateアクションに送信されるようにします。
  # updateアクションでは、フォームから送信された値をparams[:content]で受け取り、
  # @post.content = params[:content]で投稿データの内容を更新します。
  def update
    @post = Post.find_by(id: params[:id])
    @post.content = params[:content]
    if @post.save
      flash[:notice] = "投稿を編集しました"
      redirect_to("/posts/index")
    else
      render("posts/edit")
    end
  end
  
  # 投稿削除
  def destroy
    @post = Post.find_by(id: params[:id])
    @post.destroy
    flash[:notice] = "投稿を削除しました"
    redirect_to("/posts/index")
  end
  
  # 正しいユーザーかを確かめる
  def ensure_correct_user
    @post = Post.find_by(id: params[:id])
    if @post.user_id != @current_user.id
      flash[:notice] = "権限がありません"
      redirect_to("/posts/index")
    end
  end

end
