class ApplicationController < ActionController::Base
  before_action :set_current_user
  
  # ログイン中のユーザーを取得する
  def set_current_user
    @current_user = User.find_by(id: session[:user_id]) if session[:user_id]
  end
  
  # ユーザーを認証する
  def authenticate_user
    # @current_userがauthenticate_userメソッドの中でも使用されていることに注目しましょう。
    # @変数で定義した変数は同じクラスの異なるメソッド間で共通して使用することが可能です。
    if @current_user == nil
      flash[:notice] = "ログインが必要です"
      redirect_to("/login")
    end
  end
  
  # ログインユーザーを禁止する
  def forbid_login_user
    if @current_user
      flash[:notice] = "すでにログインしています"
      redirect_to("/posts/index")
    end
  end

end
