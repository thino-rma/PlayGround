### Git commands
- Git setup
  ```console
  $ git config --global core.editor 'vim -c "set fenc=utf-8"'
  $ git config --global user.name "user"
  $ git config --global user.email "user@example.com"
  $ git config --global -l
  ```

- Git ssh
  ```console
  $ mkdir -p ~/git_work/.ssh
  $ ssh-keygen -t rsa -f ~/git_work/.ssh/id_rsa -q -N "passphrase"
  ## add SSH key to ssh-agent (See PlayGround/docs/ssh/README.md)
  $ ssh-add ~/git_work/.ssh/id_rsa
  ## github - Settings - SSH and GPG keys - New SSH Key
  $ vi ~/.ssh/config
  host github github.com
    HostName github.com
    IdentityFile ~/git_work/.ssh/id_rsa
    User git
  $ chmod 600 ~/.ssh/config
  $ ssh -T github
  $ cd ~/git_work/
  $ git clone [-b BRANCHNAME] git@github.com:USER/REPO   # git clone git@github.com:thino-rma/PlayGround
  $ git checkout BRANCHANEM
  ```

- Operation
  ```console
  ### at first, git pull to fetch/merge into master
  $ git pull                   # fetch and merge
  ##### when you meet a conflic, you might want to roll-back the changes.
  ##### if you want to roll-back the pull operation, execute "git merge --abort" then "git reset --hard HEAD"
  ##### "git pull" is equal to executing following commands in order. 
  ##### so to roll-back the changes, you need to firstly abort merge on the repository, then reset the repository.
  #####   (1) "git fetch"  fetch resources to update origin/master. to reset this, "git reset --hard HEAD"
  #####   (2) "git merge"  merge resources origin/master into master. to reset this, "git merge --abort"
  
  ### branch (create a branch)
  $ git branch BRANCH          # create your working branch (if you have not created yet)
  ### checkout (and switch to the branch)
  $ git checkout BRANCH        # switch to the branch
  ##### you can these operations in one command: "git checkout -b BRANCH"
  
  ### edit
  $ vim FILE
  
  ### status
  $ git status                 # show the status
  $ git status -sb             # show in short style with branch name
  
  ### diff
  $ git diff FILE              # show in style same as "diff -uprN XXX YYY"
  $ git diff FILE | ydiff -s   # show side-by-side
                               # (A-1) to discard the changes on the FILE,         "git checkout HEAD -- FILE"
                               # (B-1) to go back to the point before edit,        "git reset --hard HEAD"
  
  ### add
  $ git add FILE               # add the FILE to staging area
                               # (B-2) to go back to the point just before add,    "git reset HEAD"
                               # (B-1) to go back to the point before edit,        "git reset --hard HEAD"
  
  ### commit
  $ git commit -v              # commit the FILE to branch
                               # (C-3) to go back to the point just before commit, "git reset --soft HEAD^"
                               # (C-2) to go back to the point before add,         "git reset HEAD^"
                               # (C-1) to go back to the point before edit,        "git reset --hard HEAD^"
  
  ### switch to main branch and merge the branch
  $ git checkout main
  $ git merge BRANCH
  
  ### commit on branch master
  $ git commit -v
  $ git push
  $ git branch -d BRANCH      # remove BRANCH
  ```

- Operation Flow
  ```console
     +------------+
     | remote     |
     | repositry  |
     | <<BRANCH>> |
     +------------+
       |
       | git clone -b BRANCH URL
       |         +------------+
       |         | private    |
       +=======> | repositry  |
       |         | <<BRANCH>> |
       |         +------------+
       |           ||                                              +-----------+
       |           || git branch TOPIC                             | private   |
       |           >>--------------------------------------------> | repositry |
       |           ||                                              | <<TOPIC>> |
       |           ||                                              +-----------+
       |           || git checkout TOPIC                             |
       |           >>==============================================> **
       |           :                                                 ||
       |           :                        ### JUST BEFORE EDIT ### ||
       |           :             **==============================>>> **
       |           :             ||                                  ||
       |           :             ||                                  || vim FILE, mkdir DIR
       |           :             ||                                  >>--> edit work tree
       |           :             ||                                  ||
       |           :             ||                                  || git status 
       |           :             ||                                  >>--> check status
       |           :             ||                                  ||
       |           :             ||                                  || git diff 
       |           :             ||                                  >>--> check diff
       |           :             ||                                  ||
       |           :             ||           git reset --hard HEAD  ||
       |           :             **==================================<<
       |           :             ||                                  ||
       |           :             ||          ### JUST BEFORE ADD ### ||
       |           :             ||   **=========================>>> **
       |           :             ||   ||                             ||
       |           :             ||   ||                             || git add FILE
       |           :             ||   ||                             >>--> (staged)
       |           :             ||   ||                             ||
       |           :             ||   ||                             || git status 
       |           :             ||   ||                             >>--> check status
       |           :             ||   ||                             ||
       |           :             ||   ||                             || git diff --cached
       |           :             ||   ||                             >>--> check diff
       |           :             ||   ||                             ||
       |           :             ||   ||      git reset HEAD         ||
       |           :             ||   **=============================<<
       |           :             ||   ||                             ||
       |           :             ||   ||      git reset --hard HEAD  ||
       |           :             **==================================<<
       |           :             ||   ||                             ||
       |           :             ||   ||  ### JUST BEFORE COMMIT ### ||
       |           :             ||   ||   **====================>>> **
       |           :             ||   ||   ||                        ||
       |           :             ||   ||   ||                        || git commit -v
       |           :             ||   ||   ||                        >>--> (commited)
       |           :             ||   ||   ||                        ||
       |           :             ||   ||   ||                        || git log
       |           :             ||   ||   ||                        >>--> check log
       |           :             ||   ||   ||                        ||
       |           :             ||   ||   || git reset --soft HEAD^ ||
       |           :             ||   ||   **========================<<
       |           :             ||   ||                             ||
       |           :             ||   ||      git reset HEAD^        ||
       |           :             ||   **=============================<<
       |           :             ||                                  ||
       |           :             ||           git reset --hard HEAD^ ||
       |           :             **==================================<<
       |           :                                                 ||
       |           :                                                 ||
       |           :                          git checkout BRANCH    ||
       |           ** <==============================================<<
       |           ||                                                :
       |           || ### JUST BEFORE MERGE ###                      :
       |           ** <<<===========================**               :
       |           ||                               ||               :
       |  (merged) || git merge [--no-ff] TOPIC     ||               :
       |        +--<>--> (!!CONFLICTED!!)           ||               :
       |       /   ||                               ||               :
       |      /    || vim FILE if CONFLICT          ||               :
       |     +     >>---> fix the CONFLICT          ||               :
       |     |     ||                               ||               :
       |     |     || git status                    ||               :
       |     |     >>---> check status              ||               :
       |     |     ||                               ||               :
       |     |     || git diff                      ||               :
       |     |     >>---> check diff                ||               :
       |     |     ||                               ||               :
       |     |     || git reset --hard HEAD         ||               :
       |     |     >>===============================**               :
       |     |     ||                                                :
       |     +     || git commit -v                                  :
       |      \    >>---> (commited)                                 :
       |       \   ||                                                :
       |        +->** (merge commited)                               :
       |           ||                                                :
       |           || git branch -d TOPIC                            :
       |           >>----------------------------------------------> X
       |           ||
       |           || git push origin BRANCH
       | <---------<<
  ```
