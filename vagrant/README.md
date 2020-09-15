- 新しいイメージを使うときの流れ
  - 空ディレクトリの作成、Vagrantfileの作成、初回の起動 (vagrant up)
  - ディスクサイズの確認
    - vagrant-disksizeプラグインで、ディスクサイズを調整
    - GParted-live でパーティションサイズを拡大
    - 起動を確認し、終了してスナップショット作成

- install vagrant plugin
  - vbguest
    ```console
    $ vagrant plugin install vagrant-vbguest 
    ```
    if you do not need it, in Vagrantfile
    ```
    Vagrant.configure('2') do |config|
      config.vm.box = 'ubuntu/xenial64'
      config.vbguest.auto_update = false
    end
    ```
  - disksize
    ```console
    $ vagrant plugin install vagrant-disksize
    ```
    if you want to change disksize, in Vagrantfile
    ```
    Vagrant.configure('2') do |config|
      config.vm.box = 'ubuntu/xenial64'
      config.disksize.size = '40GB'
    end
    ```
    you have to extend the partition size.  
    download gparted-live iso image (amd64) from https://gparted.org/download.php  
    mount it (set iso image on VirtualBOX Management Console)  
    run the guest on VirtualBOX Management Console,  booting from the iso image.  
    
    https://howtoubuntu.org/how-to-resize-partitions-with-the-ubuntu-or-gparted-live-cd  
    wait until starting GParted.  
    Right-click on the partition you wish to shrink.  
    Select Resize.  
    Expand into all the free space.  
    Click Apply  
    Close Gparted  
    Click Quit icon and shutdown.  
    
     
