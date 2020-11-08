### Ctrl-hとBackspaceが同じキーコードとなる問題
- 参考URL
  - http://www.hypexr.org/linux_ruboff.php
- BackspaceとDelete
  - ASCII文字BSは十進数8、16進数で0x08、リテラル表記で'^H'である。
  - ASCII文字DELは十進数127、16進数で0x7f、リテラル表記で'^?'である。
- vt100ターミナルのエミュレーション（デフォルト）
  - Ctrl-hキーが押下されると、'^H' (0x08) を送信するため、tty側で delete left が実行される。
  - Backspaceキーが押下されると、'^H' (0x08) を送信するため、tty側で delete left が実行される。
  - Deleteキーが押下されると、"\e[3~" を送信するため、tty側で delete が実行される。
  - 上記の挙動の問題点
    - Ctrl-hとBackspaceの入力が同じため、プログラム側が区別できない。
  - 備考
    - ttyとは、標準入出力となっている端末デバイス(制御端末、controlling terminal)の名前を表示するUnix系のコマンドである。 
    - なお、元来 tty とは teletypewriter（テレタイプライター：遠隔タイプライター）を意味する。
- Ctrl-hとBackspaceを区別するための設定概要
  - 使用している端末（vt100ターミナルエミュレータ）が、以下の挙動を示すように設定する。
    - (A-1) Ctrl-h で "^H" (0x08) を送信する。（これはデフォルトの挙動なので設定は不要。）
    - (A-2) Backspace で '^?' (0x7f) を送信する。（これには設定Aが必要。）
    - (A-3) Delete で "\e[3~" を送信する。（これはデフォルトの挙動なので設定は不要。）
  - 次に、bashシェル側で、以下の挙動を示すように tty を設定する。
    - (B-1) "^H" で delete left を実行する。（これはデフォルトの挙動なので設定は不要。）
    - (B-2) '^?' (0x7f) で delete left を実行する。（これには設定Bが必要。）
    - (B-3) "\e[3~" で delete  を実行する。（これはデフォルトの挙動なので設定は不要。）
  - テキストエディタ側で、必要に応じて、以下の挙動を示すように設定する。
    - (C-1) 基本的に "^H" で 任意の機能を実行する。
    - (C-2) 基本的に '^?' (0x7f) で delete left を実行する。
    - (C-3) 基本的に "\e[3~" で delete を実行する。（これはデフォルトの挙動なので設定は不要。）
- 設定A
  - Xterm (GNOME)
  - TeraTerm (Windows)
  - RLogin (Windows)
  - iTerm (Mac)
  - 確認方法
    以下のコマンドを実行し、任意のキー（Ctrl-h、Backspace、Deleteなど）を押下して Enter を押下すると、送られたコードが表示される。Ctrl-D（あるいはCtrl-C）で終了できる。
    ```console
    $ sed -n l
    ```
  - 備考
    - Ctrl-d は実行中のプロセス（上記ではsedコマンドのプロセス）に標準入力の終了を通知する。（実行中のプロセスは標準入力からeofを読み込む。）
    - Ctrl-c は実行中のプロセス（上記ではsedコマンドのプロセス）を終了を通知する。（実行中のプロセスがSIGINTシグナルを受信する。）
- 設定B
  - bashセッションで読み込まれる ```~/.bashrc``` に以下を追記する。（直接 ```$ stty erace '^?'```と実行してもよい）
    ```console
    stty erase '^?'
    ```
  - 確認方法
    ttyの設定状況は、以下のコマンドを実行して表示できる。erase項目を確認する。
    ```console
    $ stty -a
    ```
- 設定C
  - Vim
  - Vimでの確認方法
  - Emacs
  - Emacsでの確認方法
  - nano
  - nanoでの確認方法
  - micro
  - microでの確認方法