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
     
