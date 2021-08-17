### miniforge による python の 開発環境構築
- install miniforge
  ```console
  wget wget https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-x86_64.sh -O ~/Miniforge3.sh
  bash ~/Miniforge3.sh -b -p $HOME/miniforge3
  eval "$(~/miniforge3/bin/conda shell.bash hook)"
  conda init bash
  conda config --set auto_activate_base false
  conda update -n base -c defaults conda -y
  ```

- create myenv
  ```console
  conda create -n myenv python=3.6 -y
  conda activate myenv
  conda install autopep8 flake8 flake8-pep257 flake8-import-order 
  conda dectivate myenv
  ```
- other conda command
  ```console
  conda create -n myenv1 python=3.6 -y
  conda create -n myenv2 --clone myenv1
  conda remove -n myenv1 --all
  ```

- often used packages
  ```console
  # for jupyter
  conda install -n myenv -c conda-forge numpy pandas matplotlib seaborn scipy jupyter
  # for geopandas
  conda install -n myenv -c conda-forge geopandas descartes contextily folium cesiumpy
  ### pip install keplergl
  # for flask/gunicorn
  conda install -n myenv -c conda-forge flask gunicorn
  # for PostgreSQL
  conda install -n myenv -c conda-forge psycopg2
  # for selenium/chrome
  conda install -n myenv -c conda-forge selenium chromedriver-binary
  # for csv
  conda install -n myenv -c conda-forge csvkit visidata
  ```

### 静的コード解析
- flake8
  指摘してくれる。
  ```console
  $ flake8 script.py
  ```
- autopep8
  オプション ```-i``` でファイルをインプレース置換できる。
  ```console
  $ autopep8 -i script.py
  ```

### gunicornによる起動
- WSGIサーバとWSGIアプリについての事前知識
  - WSGI（ウィスキー）は、プログラミング言語Pythonにおいて、WebサーバとWebアプリケーション（もしくはWebアプリケーションフレームワーク）を接続するための、標準化されたインタフェース定義。
  - WSGIサーバーには、PythonモジュールとしてインストールできるgunicornやuWSGIがある。  
  - WSGIアプリケーションは、FlaskやDjangoで作成する。
    ```console
    [Web Client] ---> gunicorn ===> wsgiapp.py
    [Web Client] ---> uWSGI    ===> wsgiapp.py
    ```
  - Apacheはリバースプロキシ設定により、WSGIサーバにリクエストをプロキシできる。
    ```console
    [Web Client] ---> Apache ---> gunicorn ===> wsgiapp.py
    [Web Client] ---> Apache ---> uWSGI    ===> wsgiapp.py
    ```
  - Apacheはmod_wsgiを使ってWSGIサーバーとして、Pythonアプリケーションを直接ホストできる。
    ```console
    [Web Client] ---> Apache ---> mod_wsgi ===> wsgiapp.py
    ```
- 起動  
  例：flaskapi.pyにてapp変数がFlaskインスタンスである場合
  ```console
  $ cat flaskapi.py | grep Flask
  from flask import Flask
  app = Flask(__name__)
  $ gunicorn -c gunicorn_conf.py flaskapi:app
  ```
- 設定ファイル gunicorn.conf
  ```console
  $ cat gunicorn_conf.py 
  import multiprocessing
  
  # Worker Processes
  bind = "0.0.0.0:8000"
  workers = multiprocessing.cpu_count() * 2 + 1
  worker_class = 'sync'
  worker_connections = 1000
  timeout = 30
  keepalive = 2
  
  # Logging
  errorlog = './gunicorn.error.log'
  accesslog = './gunicorn.access.log'
  loglevel = 'info'
  logconfig = None
  
  def post_fork(server, worker):
      server.log.info("Worker spawned (pid: %s)", worker.pid)
  
  def pre_fork(server, worker):
      pass
  
  def pre_exec(server):
      server.log.info("Forked child, re-executing.")
  
  def when_ready(server):
      server.log.info("Server is ready. Spawning workers")
  
  def worker_int(worker):
      worker.log.info("worker received INT or QUIT signal")
  
      ## get traceback info
      import threading, sys, traceback
      id2name = {th.ident: th.name for th in threading.enumerate()}
      code = []
      for threadId, stack in sys._current_frames().items():
          code.append("\n# Thread: %s(%d)" % (id2name.get(threadId,""),
              threadId))
          for filename, lineno, name, line in traceback.extract_stack(stack):
              code.append('File: "%s", line %d, in %s' % (filename,
                  lineno, name))
              if line:
                  code.append("  %s" % (line.strip()))
      worker.log.debug("\n".join(code))
  
  def worker_abort(worker):
      worker.log.info("worker received SIGABRT signal")
  ```

### python script の systemd サービス化
- 起動スクリプト /usr/local/start_service.sh
  > ポイントは、```export PYTHONUNBUFFERED=1``` である。  
  > あるいは、pythonコマンドに ```-u``` オプションを指定する。```python -u script.py```
  
  ```console
  $ sudo vim /usr/local/start_service.sh
  $ chmod 755 /usr/local/start_service.sh
  $ ls -alF /usr/local/start_service.sh 
  -rwxr-xr-x. 1 root root 207 Oct 10 16:07 /usr/local/start_service.sh*
  $ sudo cat /usr/local/start_service.sh
  #!/usr/bin/env bash
  
  eval "$('/home/vagrant/miniconda/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
  conda activate flask
  cd /home/vagrant/python_work/flask
  export PYTHONUNBUFFERED=1
  python hello.py -h 0.0.0.0 -p 5000 >> /tmp/hello.log 2>&1
  ```
- サービスのユニットファイル /etc/systemd/system/hello.service 
  ```console
  $ sudo vim /etc/systemd/system/hello.service 
  $ ls -alF /etc/systemd/system/hello.service 
  -rw-r--r--. 1 root root 249 Oct  9 15:37 /etc/systemd/system/hello.service
  $ sudo cat /etc/systemd/system/hello.service 
  [Unit]
  Description = hello daemon
  
  [Service]
  User = vagrant
  ExecStart = /usr/local/start_service.sh
  ExecStop = /bin/kill ${MAINPID}
  Restart = always
  Type = simple
  StandardOutput=journal
  StandardError=journal 
  
  [Install]
  WantedBy = multi-user.target
  ```
  > ユニットファイルには、環境変数を指定するための仕組みがあります。  
  > 環境変数 ```PYTHONUNBUFFERED=1``` をエクスポートするために、  
  > ユニットファイルの ```Environment=``` あるいは ```EnvironmentFile=``` を活用することができます。  
  > この内容は、一般ユーザが ```systemctl show hello``` を使用して確認することができます。

- サービスの制御
  ```console
  $ sudo systemctl daemon-reload
  $ sudo systemctl start   hello; sleep 1; sudo systemctl status hello
  $ sudo systemctl restart hello; sleep 1; sudo systemctl status hello
  $ sudo systemctl stop    hello; sleep 1; sudo systemctl status hello
  $ sudo systemctl status hello
  $ sudo journalctl -u hello
  $ sudo journalctl -f -u hello
  ```

## 説明資料
### 前提知識
- カーネルとシェル
  - あなたがLinuxの初心者なら、カーネルはLinuxの中核機能、シェルはLinuxを操作するための外殻機能と覚えておこう。
  - Linuxへの理解を深めるために、もう少し踏み込んだ説明を紹介する。
    - カーネルプログラムとは、ハードウェアを制御するためのプログラムを指す。これに対し、一般的なプログラムは、カーネルが提供する関数（インターフェース）を使って処理を行う。
    - シェルプログラムとは、カーネルが提供する関数（インターフェース）を用いて様々な処理を行うプログラムを指す。他のプログラムの起動なども、シェルプログラムを通じて行う。
  - カーネルとシェルが分かれているメリット
    - 様々なハードウェアがそれぞれの制御方法を要求するにもかかわらず、カーネル側で違いを吸収することで、シェル側からは（ハードウェアの）違いを意識することなく利用できる。
    - カーネルは利用できるすべての権限を使ってハードウェアを制御する。一方、シェル側では、ユーザをログイン認証することで区別し、適切な権限を割り当て、操作の可否を判断できる。
  - 結論
    - あなたはシェルにログインし、あなたの権限でプログラムを起動する。そのプログラムは、カーネルの機能を利用して、処理を遂行している。
    - カーネルが提供する関数（インタフェース）は、C言語の関数として提供される。
      - より正確には、アセンブリで最もコアなシステムコールを実装し、システムコールを組み合わせてカーネルAPIを実装している。
      - カーネルが提供する機能は、今では様々な言語から利用できるようになっているが、これらは（ほぼ）すべてC言語の関数呼び出しに変換される。
  - イメージ
    - ユーザはシェルに対してコマンドを実行します。
    - シェルは入力されたコマンドを解析して、カーネルの機能を呼び出します。
    - カーネルはハードウェアを制御します。
    
    ```
                +----------------------------+       +----------+----------------------+
                |                            |       | hardware |                      |
                |              +--------------+      |          | <--> CPU             |
    User <----> | shell <----> | kernel       |      |  Memory  | <--> HDD/SSD         |
                |              |              | ---> |          | <--> DVD             |
                |              |              | <--- |  Bridge  | <--> Monitor         |
                |              +--------------+      |          | <--> Keyboad/Mouse   |
                |                            |       |          |                      |
                +----------------------------+       +----------+----------------------+
    ```
- コンソールとターミナル
  - あなたがLinuxの初心者なら、コンソールは制御するための機器（キーボードやマウスなど）、ターミナルはシェルアクセスするためのソフトウェア（xtermなど）と覚えておこう。
  - Linuxへの理解を深めるために、もう少し踏み込んだ説明を紹介する。
    - 大昔、大型のコンピュータ（汎用機あるいはメインフレーム）には、それを制御するための制御盤があり、オペレータは制御盤を操作することで作業を行っていた。
    - 制御盤には、表示装置（出力装置）とスイッチなど（入力装置）が備わっており、シェルを操作していた。このような制御盤のことを、元来「コンソール」と呼ぶ。
    - のちに、重要な操作と一般的な操作を制御盤として分離し、管理者と一般ユーザにそれぞれ配置させるようになる。
    - どの操作をどのユーザに割り当てるかを自由に行うためには、物理的なスイッチを配置するのではなく、汎用の入力装置であるキーボード・マウスを用いて、ソフトウェアで入力を判断するほうが効率的である。
    - このように入力を受け付け、結果を表示するようなソフトウェアが生まれ、これを元来「ターミナル」と呼ぶ。
    - つまり専用の物理的な「コンソール」は、汎用のモニタ・キーボード・マウスと「ターミナル」ソフトウェア、および「シェル」プログラムの組み合わせに移り変わっていったのである。
    - 一方で、コンピュータ側も徐々に進化し、様々なコンピュータが登場してきて、それに応じて様々なシェルプログラムが誕生した。
    - そのため、「ターミナル」は、現在のモニタへの出力方法やキーボード・マウスからの入力方法を抽象化する役割に徹し、シェルプログラムと通信規格をやり取りして、適切に表示・操作できるように進化してきた。
    - 現在のLinuxでは、複数の「仮想コンソール」を提供している。「仮想コンソール」を切り替えることで、モニタ・キーボード・マウスは選択された「仮想コンソール」と結び付けられる。
    - 各仮想コンソール上では「ターミナル」ソフトウェアが起動しており、結び付けられたモニタへの出力、および結び付けられたキーボード・マウスからの入力を処理する。
    - なお、LinuxをGUIで起動した場合は、ひとつ一つのウィンドウが「コンソール」として動作するイメージとなる。アクティブなウィンドウが、キーボード・マウスからの入力を処理する。
    - GUIで起動した場合には、「仮想ターミナル」ソフトウェアを起動することで、シェルにアクセスすることができる。
  - イメージ
    - ユーザはモニターを見て、サーバの状況を把握します。
    - ユーザはキーボード・マウスを操作して、シェルに対してコマンドを実行します。
      - ことのき、キーボード・マウスの信号はカーネルが受け取り、入力された内容をターミナルデバイスファイル /dev/ttyS0 に書き込みます。
      - ターミナルデバイスと接続されたターミナルプロセスは書き込まれた内容を読み取り、結びつけらたシェルプロセスに通知します。
      - シェルプロセスは通知された内容を読み取り、必要な処理を行います。（入力判断、プログラム実行など）
    
    ```
                                              +------------+
     +------+       +----------------+        | kernel     |       +----------+       +-------+
     | User | <---- | Monitor        | <----- |            | <---> | terminal | <---> | shell |
     |      |       +----------------+        |            |       |          |       +-------+
     |      |       +----------------+        |            |       |          +---------------+
     |      | ----> | Keyboard/Mouse | -----> | /dev/ttyS0 | <---> |                          |
     +------+       +----------------+        |            |       +--------------------------+
                                              +------------+
    ```

- プロセスとジョブ
  - あなたがLinuxの初心者なら、プロセスはカーネルが管理する実行単位、ジョブはシェルが管理する実行単位と覚えておきましょう。
  - Linuxへの理解を深めるために、もう少し踏み込んだ説明を紹介する。
    - 全てのプログラムはカーネルによって起動され、この処理単位をプロセスという。プロセスを識別するためのIDとしてプロセスIDがカーネルによって割り当てられる。
    - シェルから起動するプログラム（プロセス）も同様である。ただし、シェルから起動したプロセスは、そのシェルのジョブとして管理され、ジョブIDがシェルによって割り当てられる。
    - 多くの場合、シェルから起動するプロセスはそのプロセスが終了するまでターミナルの入出力を占有する。この場合、プロセスをフォアグラウンドで起動する、という。
    - しかし、ターミナルの入出力を占有させずにプロセスを起動する方法もある。この場合、プロセスをバックグラウンドで起動する、という。
  - プロセスの管理
    - プロセスの一覧を見るには、psコマンドを実行する。すべてのプロセスを表示する多面い```ps aux```のようにオプションを指定することが多い。
    - プロセスの親子関係を見るには、pstreeコマンドを実行する。
    - プロセスを終了するには、killコマンドにプロセスジョブIDを指定して実行する。（オプションなしの場合はTERMシグナルの送信）
    - プロセスを強制終了するには、killコマンドにプロセスジョブIDを指定し、なおかつオプションに-KILLをつけて実行する。（KILLシグナルの送信）
  - ジョブの管理
    - これから起動するプログラムのプロセスをバックグラウンドで起動するには、コマンド文字列の末尾に ``` &``` をつけて実行する。
    - 現在のフォアグラウンドプロセスをバックグラウンドプロセスにするには、Ctrl-Zでプロセスを停止し、bgコマンドにジョブIDを指定して実行する。
    - 現在のバックグランドプロセス（停止中のものも含む）は、jobsコマンドでリストできる。
    - 現在のバックグランドプロセス（停止中のものも含む）をフォアグランドプロセスにするには、fgコマンドにジョブIDを指定して実行する。
- 環境変数とシェル変数
  - あなたがLinuxの初心者なら、環境変数は多くのプロセスに影響を与えるパラメータ、シェル変数はプロセスに影響を与えないパラメータと覚えておきましょう。
  - Linuxへの理解を深めるために、もう少し踏み込んだ説明を紹介する。
    - シェル変数は、そのシェルプロセスだけが解釈する変数です。そのシェルから起動する子プロセスは、シェル変数を感知しません。（プロセス起動時に変数展開されて引数に渡される場合はある）。
    - 環境変数は、そのシェルプロセスで起動した子プロセスに渡され、プロセスの情報の一部として保持される変数です。
    - シェル変数は親プロセスから子プロセスに引き継がれませんが、環境変数は親プロセスから子プロセスに引き継がれます。
    - シェル変数の定義は、シェル上で、```変数=値``` （例：```HOGE=who```）を実行します。
    - シェル変数を削除するには、シェル上で、```unsert 変数``` （例：```unsert HOGE```）を実行します。
    - 定義済みのシェル変数の一覧を表示するには、setコマンド（引数なし）を実行します。
    - 環境変数の定義は、exportコマンドを用いてシェル変数を指定 （例：```export HOGE```）するか、exportコマンドにシェル変数定義を指定（```export HOGE=who```）して実行します。
    - 環境変数を削除するには、シェル上で、```export -n 変数``` （例：```export -n HOGE```）を実行します。
    - 定義済みの環境変数の一覧を表示するには、exportコマンド（引数なし）を実行します。
- コマンド検索パスを設定する環境変数PATH
  - あなたがLinuxの初心者なら、環境変数PATHにディレクトリを追加すると、入力したコマンド名と同じファイル名をもつファイルを実行してくれる、覚えておきましょう。
  - Linuxへの理解を深めるために、もう少し踏み込んだ説明を紹介する。
    - シェルは、入力されたコマンドを確認し、実行する。
    - シェルは、ビルトインコマンドを提供するほか、シェル関数やエイリアスを定義することもできるので、これらに該当するコマンド文字列は、対応する機能の呼び出しとして解釈される。
    - シェルは、これらに該当しないコマンド文字列については、それが絶対パスや相対パスでない場合、PATHに記載されたディレクトリを順に確認し、同名のファイルがあればそれを起動する。
  - プログラムが配置されるべきディレクトリ
    - /usr/binや/usr/local/binは一般ユーザ向けコマンドが格納される。
    - /usr/sbinや/usr/local/sbinは管理者ユーザ向けコマンドが格納される。
    - 最近は /bin や /sbin は用いられない。/usr/binや/usr/sbinへのシンボリックリンクとなっている。
    - ~/bin には、自分だけが使用するコマンドを格納する。
  - 環境変数の記載順位と優先度
    - 環境変数PATHのディレクトリは、先頭から順に検索される。同じファイル名で複数の場所に配置されている場合には、PATHの設定によってどちらが起動されるかが決まることになる。
 
### Miniforgeのcondaコマンドの挙動について
- 前提
  - Miniforgeがインストールされたディレクトリを ~/miniforge3/とします。
- condaコマンドとは何ですか
  - Anaconda社が提供するPythonのモジュール管理コマンドです。conda関数として定義されます。
- condaコマンドはどうやったら使えますか。
  - まず、miniforgeをインストールしてください。
  - インストーラをバッチモードで実行した直後では、conda関数は定義されていないので、使用できません。。```eval "$(~/miniforge3/bin/conda shell.bash hook)"```を実行して base 環境を有効化します。
  - 【bash利用者向け】.bashrcを修正するために、```conda init bash```を実行します。次回ログインから、base環境が自動で有効化されます。
    - 次回起動時から、環境変数PATHの先頭に、~/miniconda3/condabin が追加されるようになります。これにより、condaコマンドが使用できるようになります。
    - 次回起動時から、仮想環境 base が自動で有効化されるようになり、環境変数PATHの先頭に、~/miniconda3/bin が追加されるようになります。
    - 仮想環境 base を自動で有効化したくない場合は、```conda config --set auto_activate_base false``` を実行してください。
- conda create -n myenv が行うことは何ですか
  - ~/miniforge3/envsの下に、myenvディレクトリを作成し、その配下に bin や lib といったディレクトリを作成して、各種モジュールをインストールします。
- conda activate myenv が行うことは何ですか
  - 仮想環境myenvを有効化します。
    - 環境変数PATHを変更します。具体的には先頭に、 ~/miniconda3/envs/myenv/binを追加します。以下で確認してください。
      ```
      (myenv) $ echo $PATH
      ```
    - Python実行時のモジュール検索パスを変更します。具体的には仮想環境ディレクトリ ~/miniconda3/envs/myenv/ 以下を追加します。以下で確認してください。
      ```
      (myenv) $ python3 -c "import sys; print(sys.path)"
      ```

## old contents
### miniconda による python の 開発環境構築
- install miniconda
  ```console
  wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh
  bash ~/miniconda.sh -b -p $HOME/miniconda
  eval "$(~/miniconda/bin/conda shell.bash hook)"
  conda init bash
  conda config --set auto_activate_base false
  conda update -n base -c defaults conda -y
  ```

- create myenv
  ```console
  conda create -n myenv python=3.6 -y
  conda activate myenv
  conda config --set channel_priority strict --file $CONDA_PREFIX/.condarc
  conda config --add channels conda-forge    --file $CONDA_PREFIX/.condarc
  conda install autopep8 flake8 flake8-pep257 flake8-import-order 
  conda dectivate myenv
  ```
