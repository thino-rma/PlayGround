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
- other conda command
  ```console
  conda create -n myenv1 python=3.6 -y
  conda create -n myenv2 --clone myenv1
  conda remove -n myenv1 --all
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


