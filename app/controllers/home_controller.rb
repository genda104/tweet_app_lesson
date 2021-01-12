class HomeController < ApplicationController
  before_action :forbid_login_user, {only: [:top]}      #ApplicationControllerで定義

  # アクションは、コントローラと同じ名前のビューフォルダから、アクションと同じ名前のHTMLファイルを探してブラウザに返します。
  def top
  end
  
  def about
  end

end
