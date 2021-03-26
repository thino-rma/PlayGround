### ドラフト
- バックアップとは
  - ファイル群をコピーしておくこと。
- ディレクトリのバックアップに使用できるコマンド
  - tarコマンド アーカイブファイルを作成する
    - 指定したディレクトリをtgzファイルにアーカイブします。
    - Usage
      ```console
      $ tar zcvf ARCHIVEFILE SRC
      ```
    - SRCをディレクトリとする場合だけを考えます。
    - 礼儀として、SRCには相対パスを指定してください。
    - 展開には、以下のコマンドを使用します。
      ```console
      $ tar zxvf ARCHIVEFILE
      ```
  - cpコマンド 複製する
    - Usage
      ```console
      $ cp [OPTION] SRC DEST
      ```
    - SRCをディレクトリとする場合だけを考えます。
    - DESTの有無
      ```console
      $ cp -av /path/to/src /path/to/dest
      ```
      ```/path/to/```に```dest```ディレクトリがなければ、```src```を```dest```として複製する。  
      つまり、```/path/to/src```を```/path/to/dest``` として複製する。  
      ```/path/to/```に```dest```ディレクトリがあれば、```src```を```dest```ディレクトリ以下に作成するかたちで複製する。  
      つまり、```/path/to/src```を```/path/to/dest/src``` として複製する。
  - rsyncコマンド
    - Usage
      ```console
      $ rsync [OPTION] SRC DEST
      ```
    - DESTはディレクトリ。
      - DESTの親ディレクトリが存在しない場合は、エラーとなる。前もって作っておくこと。DRY RUNはエラーにならない。
    - SRCをディレクトリとする場合だけを考えます。
    - DESTの有無  
      無ければ作成されます。
    - SRCの末尾の```/```の有無：ないとき
      ```console
      $ rsync -auv /path/to/src /path/to/dest
      ```
      無ければ、srcをdest/srcと同期する。  
      つまり、```/path/to/src```を```/path/to/dest/src``` として同期する。
    - SRCの末尾の```/```の有無：あるとき
      ```console
      $ rsync -auv /path/to/src/ /path/to/dest
      ```
      有れば、srcをdestと同期する。  
      つまり、```/path/to/src/*```を```/path/to/dest/*``` として同期する。
- どのようなバックアップをとるか
  - (1) ローカルでファイルシステム内のバックアップ
    - 手段① cpコマンド ```$ cp -av SRC DEST```
      - 完全に複製する。
    - 手段② cpコマンド ```-alv```
      - ハードリンクとして複製する。（容量があまり増えない）
    - 手段③ rsyncコマンド ```-auv```
      - SRCからDESTに同期する。
        オプション```-a```で、archiveバックアップする。```-rlptgoD``` と同じ。  
        オプション```-u```で、転送先の新しいファイルを上書きしない。  
        オプション```-v```で、コピーしたファイル名やバイト数などの転送情報を出力する。
    - 手段④ rsyncコマンド ```-auv --delete```
      - 完全な同期をとるときに使う。  
        オプション```--delete```で、SRCに存在しないファイルは、DESTにあれば削除する。
    - 手段⑤ rsyncコマンド ```-auv --delete --link-dest=DIR```
      - 増分バックアップをとるときに使用する。  
        オプション```--link-dest=DIR```で、そのDIRにあるファイルと同じファイルはハードリンクが作成される。
        > DIRには、絶対パスを指定するか、DESTからの相対パスを指定する。
  - (2) ローカルでファイルシステムをまたぐバックアップ
    - ハードリンクが作成できない。よって、手段②や⑤は使えない。
    - はじめて作成するときには、手段①か手段③を使えばよい。
    - すでに存在するディレクトリに同ｑ期するためには、手段④を使う。
  - (3) リモートサーバからバックアップサーバにバックアップ
    - 手段⑥ rsyncコマンド ```-auv -e "ssh -l USER -i KEYFILE -p 22" --delete```
      - リモートバックアップをとるときに使用する。  
        オプション```-e "..."```で、SSHコマンドとそのオプションを指定できる。
    > オプション ```--link-dest=DIR```は使えるのか？比較はいつ行われるのか？
  - rsyncの気になるオプション
    - オプション```-n```でDRY RUNして確認する
      ```console
      $ rsync -auv -n /path/to/src /path/to/dest
      ```
    - オプション```--max-size``` で転送対象のファイルサイズの上限を指定する。
    - オプション```--exclude=PATTERN``` で同期から除外する。
    - オプション```--bwlimit=RATE``` で最大転送速度を指定する。
      > 単位はKiBps（1以上）。帯域制限例としては、以下のような値を使うことが多い陽だ。  
      > 500kbps=62.5(KBps)、1Mbps=125(KBps)
  - 負荷が高いとき
    - ioniceコマンドとniceコマンドを用いる。
      ```console
      $ ionice -c3 nice -n 19 rsync -e "ssh" --bwlimit=8192 remotehost:/remote_srcdir/ /local_destdir
      ```
    - trickleコマンドでIOを制限することもできる。（```--bwlimit=KBPS```を使う方がよい。）
      ```console
      $ trickle -s -d キロバイト -u キロバイト rsync ...
      ``` 
- 単発バックアップのベストプラクティス 
  - コピー・同期にこだわらず、tgzファイルにアーカイブする。
    - tarコマンドでアーカイブを作ってしまう。
  - ローカルホスト内で、同じファイルシステム内で、単発でバックアップを作りたい時
    - 手段②でコピーをハードリンクで作成する。
  - ローカルホスト内で、ファイルシステムをまたいで、バックアップを作りたい時
    - 手段③で複製を作成する。
    - あるいはtarコマンドでアーカイブを作ってしまう。
  - リモートホストにバックアップを作りたい時
    - tarコマンドでアーカイブを作って、それをscpで転送し、必要ならリモートで展開する。
- 継続的なバックアップのベストプラクティス 
  - ローカルホスト内で、同じファイルシステム内で、継続的にバックアップを作りたい時
    - 初回は手段②でコピーをハードリンクで作成する。
    - ２回目以降は手段⑤で増分バックアップを作成する。
  - ローカルホスト内で、ファイルシステムをまたいで、バックアップを作りたい時
    - 初回は手段③で複製を作成する。
    - ２回目以降は、前回に作ったものを手段②で複製バックアップを作ってから、手段④で同期する。
  - リモートホストに増分バックアップを作りたい時
    - 初回は手段③で複製を作成する。
    - ２回目以降は、前回に作ったものを手段②で複製バックアップを作ってから、手段④で同期する。
- SSH接続でコマンドを制限する
  - 参考URL：[rsync+ssh2の設定の巻](http://www.sea-bird.org/pukiwiki_utf/index.php?rsync%2Bssh2%E3%81%AE%E8%A8%AD%E5%AE%9A%E3%81%AE%E5%B7%BB)
    > rsyncコマンドのみを許す設定
    > サーバ側のsshに「PermitRootLogin forced-commands-only」と指定したことにより、ssh経由でrootユーザでの実行が可能となります。ただし許可されたコマンドのみ実行が可能なので、その登録方法を説明します。  
    > ここでも説明もこんがらがるので、サーバ側、バックアップ側として説明します。  
    > サーバ側で、実際に実行するrsyncコマンドを実行してみます。
    > ```console 
    > server# /usr/bin/rsync -vv -az -e "ssh -2 -i/root/.ssh/rsync" /backup/ root@192.168.0.xxx:/backup/
    > opening connection using ssh -2 -i/root/.ssh/rsync -l root 192.168.0.xxx rsync --server -vvlogDtprz . /backup/
    > protocol version mismatch - is your shell clean?
    > (see the rsync man page for an explanation)
    > rsync error: protocol incompatibility (code 2) at compat.c(60)
    > ```
    > 必ずエラーとなります  
    > rsync error: protocol incompatibility (code 2) at compat.c(60)  
    > 上記のエラーが表示されますが、ここでの注目して欲しい点は、「rsync --server -vvlogDtprz . /backup/」です。  
    > このコマンド結果をバックアップ側に登録します。  
    > 
    > バックアップ側の、/root/.ssh/authorized_keys ファイルを開き rsyncの公開鍵(rsync.pub)で登録した行の先頭に上記で注目してという「rsync --server -vvlogDtprz . /backup/」を追加します。  
    > 実際には command="" というのを追加します。
    > 
    > ```console 
    > backup# vi /root/.ssh/authorized_keys         
    > command="rsync --server -vvlogDtprz . /backup/" ssh-dss xxxxxxxxx
    > ```
