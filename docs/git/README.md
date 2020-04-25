### Git commands
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
