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

### python script の systemd サービス化
- 起動スクリプト /usr/local/start_service.sh
  > ポイントは、```python -u script.py``` である。
  
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
  python -u hello.py -h 0.0.0.0 -p 5000 >> /tmp/hello.log
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
- サービスの制御
  ```console
  $ sudo systemctl daemon-reload
  $ sudo systemctl start hello; sleep 1; sudo systemctl status hello
  $ sudo systemctl stop  hello; sleep 1; sudo systemctl status hello
  $ sudo systemctl status hello
  $ sudo journalctl -u hello
  $ sudo journalctl -f -u hello
  ```


