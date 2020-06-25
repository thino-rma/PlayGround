- msortf_add_n.patch
  - for mcmd version 3:1:0:0
  - patch file to add ```n=``` option to msortf command, which specify the header line for output.
  - install
    ```
    ## install autotools,boost,libxml2 if not installed
    $ sudo apt-get update
    $ sudo apt-get upgrade
    $ sudo apt-get install build-essential
    $ sudo apt-get install git
    $ sudo apt-get install libboost-all-dev
    $ sudo apt-get install libxml2-dev
    
    ## download the sources
    $ mkdir ~/nysol; cd ~/nysol
    $ git clone https://github.com/nysol/mcmd
    $ cd mcmd
    
    ## patch
    $ wget https://raw.githubusercontent.com/thino-rma/PlayGround/master/nysol/mcmd/msortf_add_n.patch
    $ patch -s -p1 < msortf_add_n.patch
    
    ## compile and install
    $ aclocal
    $ autoreconf -i
    $ ./configure
    $ make
    $ sudo make install
    
    # setting a shared library path
    # write it in .bash_profile if you like to activated it automatically.
    $ export LD_LIBRARY_PATH=/usr/local/lib
    ```
  - how to use
    ```
    msortf --help
    msortf --helpl
    ### generate sample data
    mdata tutorial_en
    ### normal usage
    msortf f=Category1                  i=./tutorial_en/jicfs1.csv o=result.csv
    msortf -x f=1                       i=./tutorial_en/jicfs1.csv o=result.csv
    ### n= opution to specify the header line
    msortf f=Category1 n=ID,NAME%0      i=./tutorial_en/jicfs1.csv o=result.csv
    msortf -x f=1 n=ID,NAME%0           i=./tutorial_en/jicfs1.csv o=result.csv
    ### -noflg option to omit sort flag
    msortf -noflg f=Category1           i=./tutorial_en/jicfs1.csv o=result.csv
    msortf -noflg -x f=1                i=./tutorial_en/jicfs1.csv o=result.csv
    ### n= opution to specify header line, -noflg option to omit sort flag
    msortf -noflg -x f=1 n=ID,NAME      i=./tutorial_en/jicfs1.csv o=result.csv
    msortf -noflg f=Category1 n=ID,NAME i=./tutorial_en/jicfs1.csv o=result.csv
    ### process CSV file without header
    tail -n +2 ./tutorial_en/jicfs1.csv | msortf -nfn f=1 n=ID,NAME%0 o=result.csv
    tail -n +2 ./tutorial_en/jicfs1.csv | msortf -nfn f=1 n=ID,NAME   o=result.csv
    ```
