desc "Update pot/po files."
task :updatepo do
  require 'gettext/utils'
  GetText.update_pofiles("dokoiku", #テキストドメイン名(init_gettextで使用した名前) 
                         Dir.glob("{app,config,components,lib}/**/*.{rb,rhtml}"),  #ターゲットとなるファイル
                         "dokoiku 1.0.0"  #アプリケーションのバージョン
                         )
end

desc "Create mo-files"
task :makemo do
  require 'gettext/utils'
  GetText.create_mofiles(true, "po", "locale")
end
