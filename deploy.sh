#该脚本实现myblog/content下的文章更新、config.toml配置文件更新和同时部署到gitee码云和github

#git博客站点主要文件
git add config.toml
git add content/*
git add deploy.sh
git add README.md

# Commit changes.
msg="rebuilding site `date`"
if [ $# -eq 1 ]
  then msg="$1"
fi
git commit -m "$msg"
#删除url并重新添加url
git remote rm origin
git remote add origin https://github.com/code-chf/myblog.git
git push -u origin master



#自动部署到gitee码云
echo "\033[0;32mDeploying updates to Gitee...\033[0m"
# 用hugo建立一个静态站点
hugo --baseURL="https://codechf.gitee.io"
# Go To Public folder
cd public
# Add changes to git.
# git init
git add .
# Commit changes.
msg="rebuilding site `date`"
if [ $# -eq 1 ]
  then msg="$1"
fi
git commit -m "$msg"
#删除url并重新添加url
git remote rm origin
git remote add origin https://gitee.com/codechf/codechf.git
# Push source and build repos.
git push -u origin master
# Come Back up to the Project Root
cd ..



#同步部署到github上面
echo "\033[0;32mDeploying updates to GitHub...\033[0m"
#自定义创建public_github发布目录
hugo --destination="public_github"
# Go To Public folder
cd public_github
# git init
git add .
# Commit changes.
msg="rebuilding site `date`"
if [ $# -eq 1 ]
  then msg="$1"
fi
git commit -m "$msg"
#删除url并重新添加url
git remote rm origin
git remote add origin https://github.com/code-chf/code-chf.github.io.git
# Push source and build repos.
git push -u origin master
# Come Back up to the Project Root
cd ..


#部署到个人本地服务器
echo "\033[0;32mDeploying updates to Server...\033[0m"
#自定义创建public_server发布目录
hugo --destination="public_server" --baseURL="/"
# Go To Public folder
cd public_server
# git init
git add .
# Commit changes.
msg="rebuilding site `date`"
if [ $# -eq 1 ]
  then msg="$1"
fi
git commit -m "$msg"
#删除url并重新添加url
git remote rm origin
git remote add origin git@ipv6.codechf.cn:/home/gitrepo/public_server.git
# Push source and build repos.
git push origin master
# Come Back up to the Project Root
cd ..