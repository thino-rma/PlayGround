### gitをローカルで使ってみる
- gitを使う方法
  - (1) GitHubデビューする
    - GitHubでリポジトリを作成し、Webアクセスだけで操作する。
    - GitHubのリポジトリをローカルにクローンして、修正分をCommitし、GitHubにPushする。
    - ★GitHubのリポジトリを、別のリポジトリに移行する。
  - (2) ローカルホストでローカルリポジトリを試してみる。
    - git initでローカルリポジトリを作成し、修正分をCommitする。
    - ★GitHubにリポジトリを作成し、ローカルリポジトリをGitHubに移行する。
    - ★GitHubのリポジトリをローカルにクローンして、修正分をCommitし、GitHubにPushする。
- ローカルのリポジトリをgithubに移行する
  - 流れ
    - ある日、gitでローカルリポジトリを作り、バージョン管理を始める。
    - やがて、GitHubにリポジトリを移行したい、と考える。
  - やりかた
    (1) リモートリポジトリoriginのpush用URLを移行先に変更し、
    (2) 移行先にmirrorモードでpushする。
    ```console
    ### (1)
    ~/git_work $ git remote add origin git@github.com:hogehoge/hoge.git
    ### (2)
    ~/bit_work $ git push --mirror
    ```
- Bitbucketからgithubに移行する
  - 流れ
    - ある日、GitHubでリモートリポジトリを作り、バージョン管理を始める。
    - やがて、別のリポジトリを移行したい、と考える。
  - やりかた
    (1) 移行元からmirrorモードでcloneして
    (2) リモートリポジトリoriginのpush用URLを移行先に変更し、
    (3) 移行先にmirrorモードでpushする。
    (4) 別途、移行先からcloneして作業する。
    (5) 問題なければ、(1)でつくったローカルリポジトリを削除する。
    (6) 問題なければ、移行元のリモートリポジトリを削除する。
    ```console
    ### (1)
    ?? $ cd ~/
    ~/ $ mkdir bit_work
    ~/ $ cd bit_work
    ~/bit_work $ git clone --mirror git@bitbucket.org:hogehoge/hoge.git
    ### (2)
    ~/bit_work $ git remote set-url --push origin git@github.com:hogehoge/hoge.git
    ### (3)
    ~/bit_work $ git push --mirror
    ### (4)
    ~/bit_work $ cd ~/
    ~/ $ mkdir git_work
    ~/ $ cd git_work
    ~/git_work $ git clone git@github.com:hogehoge/hoge.git
    ### (5)
    ~/git_work $ cd ~/
    ~/ $ cd bit_work
    ~/bit_work $ rm -rf ./hoge
    ~/ $ cd git_work
    ~/git_work $ git clone git@github.com:hogehoge/hoge.git
    ```
