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
  $ mkdir ^-p ~/git_work/.ssh
  $ ssh-keygen -t rsa -f ~/git_work/.ssh/id_rsa -q -N "passphrase"
  $ vi ~/.ssh/config
  host github github.com
    HostName github.com
    IdentityFile ~/git_work/.ssh/id_rsa
    User git
  $ chmod 600 ~/.ssh/config
  $ ssh -T github
  $ git clone [-b BRANCHNAME] git@github.com:USER/REPO
  $ git checkout BRANCHANEM
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
