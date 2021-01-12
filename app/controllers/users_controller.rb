class UsersController < ApplicationController
  # 各コントローラの全アクションで共通する処理がある場合には、before_actionを使うと全アクションで共通する処理を1箇所にまとめることができます。
  # before_actionを用いることで、アクションが呼び出される際に必ずbefore_actionの処理が実行されます。
  # onlyを用いて各コントローラでbefore_actionを使うことで、指定したアクションでのみそのメソッドを実行することができます。
  # 各コントローラは、applicationコントローラを継承しているので、継承元のメソッドを使うことができます。
  before_action :authenticate_user, {only: [:index, :show, :edit, :update]}           #ApplicationControllerで定義
  before_action :forbid_login_user, {only: [:new, :create, :login_form, :login]}      #ApplicationControllerで定義
  before_action :ensure_correct_user, {only: [:edit, :update]}
  
  def index
    @users = User.all
  end
  
  def show
    @user = User.find_by(id: params[:id])
  end
  
  def new
    @user = User.new
  end
  
  def create
    @user = User.new(
      name: params[:name],
      email: params[:email],
      image_name: "default_user.jpg",
      password: params[:password]
    )
    if @user.save
      # ユーザー登録が成功した時に、作成したユーザーがそのままログイン状態になるようにします。
      # usersコントローラのcreateアクション内で作成したユーザーのidをsession[:user_id]に代入します。
      session[:user_id] = @user.id
      flash[:notice] = "ユーザー登録が完了しました"
      redirect_to("/users/#{@user.id}")
    else
      render("users/new")
    end
  end
  
  def edit
    @user = User.find_by(id: params[:id])
  end
  
  def update
    @user = User.find_by(id: params[:id])
    @user.name = params[:name]
    @user.email = params[:email]
    
    if params[:image]
      @user.image_name = "#{@user.id}.jpg"
      image = params[:image]
      # 画像データは特殊なテキストファイルであるため、File.writeではなくFile.binwriteを用いる必要があります。
      # 変数imageに対し、readメソッドを用いることでその画像データを取得できます。
      File.binwrite("public/user_images/#{@user.image_name}", image.read)
    end
    
    if @user.save
      flash[:notice] = "ユーザー情報を編集しました"
      redirect_to("/users/#{@user.id}")
    else
      render("users/edit")
    end
  end
  
  def login_form

  end
  
  def login
    @user = User.find_by(email: params[:email])
    # password_digestカラムに暗号化されたパスワードを保存するためには、今まで通りpasswordに値を代入します。
    # こうすることで、has_secure_passwordによってpasswordに代入された値が暗号化され、password_digestカラムに保存されます。
    # このため、既にあるpasswordに関するコードを変更する必要はありません。
    # has_secure_passwordメソッドを有効にすると、authenticateメソッドを使えるようになります。
    # authenticateメソッドは渡された引数を暗号化し、password_digestの値と一致するかどうかを判定してくれます。
    if @user && @user.authenticate(params[:password])
      # ページを移動してもユーザー情報を保持し続けるために、sessionという特殊な変数を用います。
      # sessionに代入された値は、ブラウザに保存されます。ブラウザはそれ以降のアクセスでsessionの値をRailsに送信します。
      # 「session[:キー名] = 値」のように変数sessionに@user.idを代入することで、特定したログインユーザーの情報が保持され続けます。
      session[:user_id] = @user.id
      flash[:notice] = "ログインしました"
      redirect_to("/posts/index")
    else
      @error_message = "メールアドレスまたはパスワードが間違っています"
      @email = params[:email]
      @password = params[:password]
      render("users/login_form")
    end
  end
  
  def logout
    # session[:user_id]にnilを代入することで、session[:user_id]の値を空にすることができます。
    session[:user_id] = nil
    flash[:notice] = "ログアウトしました"
    redirect_to("/login")
  end
  
  # 「いいね！」をした投稿を一覧で表示する
  def likes
    @user = User.find_by(id: params[:id])
    @likes = Like.where(user_id: @user.id)
  end
  
  # 正しいユーザーかを確かめる
  def ensure_correct_user
    # @current_user.idは数値です。
    # params[:id]で取得できる値は文字列であり、to_iメソッドを用いると文字列を数値に変換することができます。
    if @current_user.id != params[:id].to_i
      flash[:notice] = "権限がありません"
      redirect_to("/posts/index")
    end
  end

end