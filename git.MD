
# Git global setup

    git config --global user.name "Username"
    git config --global user.email "user@domain.tld"

# Create a new repository

    git clone git@gitlab.domain.tld:repoName/projectName.git
    cd edugain
    touch README.md
    git add README.md
    git commit -m "add README"
    git push -u origin master

# Existing folder

    cd existing_folder
    git init
    git remote add origin git@gitlab.domain.tld:repoName/projectName.git
    git add .
    git commit -m "Initial commit"
    git push -u origin master

# Existing Git repository

    cd existing_repo
    git remote add origingit@gitlab.domain.tld:repoName/projectName.git
    git push -u origin --all
    git push -u origin --tags
