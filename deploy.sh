#本脚本实现了同时部署到gitee码云和github


#自动部署到gitee码云
#!/bin/sh
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

# 合并gitee上的文件
# git pull origin master --allow-unrelated-histories

# Push source and build repos.
git push -u origin master

# Come Back up to the Project Root
cd ..


#同步部署到github上面
#!/bin/sh
echo "\033[0;32mDeploying updates to GitHub...\033[0m"

#hugo --baseURL="https://code-chf.github.io"
hugo

#自定义创建public_github发布目录
hugo --destination="public_github"

# Go To Public folder
cd public_github

# git init
git add .

msg="rebuilding site `date`"
if [ $# -eq 1 ]
  then msg="$1"
fi
git commit -m "$msg"

#删除url并重新添加url
git remote rm origin
git remote add origin https://github.com/code-chf/code-chf.github.io.git

# 合并github上的文件
# git pull origin master --allow-unrelated-histories

# Push source and build repos.
git push -u origin master

# Come Back up to the Project Root
cd ..