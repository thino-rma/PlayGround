### Usage of tmux
- Why should you learn tmux?
  - (1) You can create panes/windows, and manage multiple terminal sessions.
    - You can copy text in the active pane with keyboard/mouse.
  - (2)```tmux``` lets you detach from and re-attach sessions, so taht you can leave your terminal sessions running in the background and resume them later.
    - If you start tmux on the remote host, you can disconnect ssh connection after detaching tmux session.
- before starting
  - PREFIX key
    - ```tmux``` uses what is called a prefix key. 
    - ```tmux``` will interpret the keystroke following the prefix as a tmux shortcut. 
    - default PREFIX key is CTRL+b (but this is a little bit far from home position).
  - you should create ```~/.tmux.conf``` if not created yet.
    ```
    $ [ -f ~/.tmux.conf ] || cat <<EOF > ~/.tmux.conf
    ### set color 256
    # you can find it in ```$ toe -a```
    set-option -g default-terminal screen-256color

    ### draw line with ACS
    set -ag terminal-overrides ',*:U8=0'

    ### set base index
    set-option -g base-index 1
    set-option -g pane-base-index 1

    ### set mouse mode
    set-option -g mouse on

    ### prefix key
    # unbind C-b
    # set -g prefix C-q
    # bind C-q send-prefix
    
    ### short cut keys
    bind-key -n M-F7     select-pane -t :.-
    bind-key -n M-F8     select-pane -t :.+
    bind-key -n M-C-F7   previous-window
    bind-key -n M-C-F8   next-window
    
    ### short cut keys F9, F10, F11, F12 with Alt: h,j,k,l
    # without Shift, change pane
    bind-key -n M-F9  select-pane -L
    bind-key -n M-F10 select-pane -D
    bind-key -n M-F11 select-pane -U
    bind-key -n M-F12 select-pane -R
    
    # with Shift, change size
    bind-key -n M-S-F9    resize-pane -L 1
    bind-key -n M-S-F10   resize-pane -D 1
    bind-key -n M-S-F11   resize-pane -U 1
    bind-key -n M-S-F12   resize-pane -R 1
    
    bind-key -n M-C-S-F9  resize-pane -L 5
    bind-key -n M-C-S-F10 resize-pane -D 5
    bind-key -n M-C-S-F11 resize-pane -U 5
    bind-key -n M-C-S-F12 resize-pane -R 5
    
    ### copy mode
    # C-@ stands for NUL '\000' which is sent by C-@ and C-Space on SSH client
    bind-key -n C-@ copy-mode
    setw -g mode-keys vi
    
    bind-key -T copy-mode-vi 'v'      send -X begin-selection
    bind-key -T copy-mode-vi 'V'      send -X select-line
    bind-key -T copy-mode-vi 'C-v'    send -X rectangle-toggle
    bind-key -T copy-mode-vi 'y'      send -X copy-selection
    bind-key -T copy-mode-vi 'Y'      send -X copy-line
    bind-key -T copy-mode-vi 'Escape' send -X clear-selection
    bind-key -T copy-mode-vi 'C-c'    send -X cancel
    
    bind-key -T copy-mode-vi 'C-a'    send -X start-of-line
    bind-key -T copy-mode-vi 'C-e'    send -X end-of-line
    bind-key -T copy-mode-vi 'w'      send -X next-word
    bind-key -T copy-mode-vi 'e'      send -X next-word-end
    bind-key -T copy-mode-vi 'b'      send -X previous-word
    
    bind-key -T copy-mode-vi 'Home'   send -X start-of-line
    bind-key -T copy-mode-vi 'End'    send -X end-of-line
    bind-key -T copy-mode-vi 'C-Home' send -X top-line
    bind-key -T copy-mode-vi 'C-End'  send -X bottom-line
    EOF
    ```
  - Which PREFIX is ideal or not depends on that person.  
    - ```C-b```   this is the default on tmux, but a little bit far from home position.  
    - ```C-a```   this is the default on screen, but it conflicts bash's key-binding "beginning-of-line"  
      > if you want to use ```C-a``` as PREFIX, change like below:
      > ```
      > ### prefix key
      > unbind C-b
      > set -g prefix C-a
      > bind C-a send-prefix
      > ```
    - ```C-q```   this is ideal PREFIX because this key is bound to ancient FLOW-CONTROL which you don't need anymore.  
      > if you want to use ```C-q``` as PREFIX, change like below:
      > ```
      > ### prefix key
      > unbind C-b
      > set -g prefix C-q
      > bind C-q send-prefix
      > ```
      > it would be better to disable C-s, C-q (ancient FLOW-CONTROL) in ```.bashrc```.
      > ```
      > # If this has a terminal for STDIN
      > if [[ -t 0 ]]; then
      >   ## disable Ctrl-S (stop), Ctrl-Q (start)
      >   stty stop undef
      >   stty start undef
      > fi
      > ```
    - ```C-[```   this may another ideal PREFIX because tmux copy-mode begins with ```[```.  
      > this requires to use both hands, but you may immediately enter copy-mode with ```C-[ [```.  
      > if you want to use ```C-[``` as PREFIX, change like below:
      > ```
      > ### prefix key
      > unbind C-b
      > set -g prefix C-[
      > bind C-[ send-prefix
      > ```
      > if you want to use ```C-[``` in vim (it is same as ESC), you can still use it with ```C-[ C-[``` (hit repeatedly!).  
  - Ctrl key 
    - You might want to change key CAPS to Ctrl.
    - On windows, see [Ctrl2Cap v2.0](https://docs.microsoft.com/en-us/sysinternals/downloads/ctrl2cap)

- start and session managing (5 items)
  - ```$ tmux``` new session 
  - ```$ tmux new -s mysession``` new session with session name
  - ```$ tmux ls``` list session namews
  - ```$ tmux att -t mysession``` attach session to named
  - ```PREFIX d``` detach from the session
    > if you want to change session-name in the session, you can use command-mode starting with ```:``` (colon)  
    > ```:rename-session mysession``` 
- copy and paste (5 items)
  > you may be happy if you make clipboard writable with OSC52 (or PASTE64) to share the contents you copy in tmux with host's clipboad.
  
  - ```PREFIX [``` start copy mode
  - ```PREFIX ]``` paste buffer
  - in copy mode ```SPACE``` start selection (mark)
  - in copy mode ```ENTER``` copy selection (and quit copy mode)
  - in copy mode ```ESC``` cancel selection
    > if you enables .tmux.conf as shown above, these keys can be used: 
    > - in copy mode ```q``` and ```Ctrl-C``` quit copy mode
    > - in copy mode ```v``` start selection
    > - in copy mode ```V(Shift-v)``` start selection (LINE)
    > - in copy mode ```y``` copy selection (and quit copy mode)
- panes (5 items)
  - ```PREFIX "(Shift-2)``` create a horizontal split
    > if it is confusing, you can map it to ```PREFIX -```
    > ```
    > bind - split-window -h # Split panes horizontal
    > ```
  - ```PREFIX %(Shift-5)``` create a virtical split
    > if it is confusing, you can map it to ```PREFIX |(Shift-\)```
    > ```
    > bind | split-window -v # Split panes vertically
    > ```
  - ```PREFIX z``` toggle zoom in/out
  - ```PREFIX o``` cycle through panes (change focus)
  - ```PREFIX x``` close pane
    > of course, ```$ exit``` close current pane  
    > you can use mouse to select/resize pane with setting ```set-option -g mouse on```
- windows (tabs)  (5 items)
  - ```PREFIX w``` list windows
  - ```PREFIX c``` create a window
  - ```PREFIX n``` next window
  - ```PREFIX p``` previous window
  - ```PREFIX &(Shift-6)``` kill window
    > of course, ```$ exit``` close current window (if in last pane)  
    > you can use mouse to select window with setting ```set-option -g mouse on```

### about Version
- Ubuntu
  - Ubuntu20.04 tmux 3.0a-2ubuntu0.2
  - Ubuntu18.04 tmux 2.6-3ubuntu0.2
- CentOS
  - CentOS8 tmux-2.7-1.el8.x86_64.rpm
    - http://galaxy4.net/repo/RHEL/8/x86_64/tmux-3.1b-3.el8.x86_64.rpm
  - CentOS7 tmux-1.8-4.el7.x86_64.rpm
    - http://galaxy4.net/repo/RHEL/7/x86_64/tmux-3.1b-3.el7.x86_64.rpm

### compile
- Ubuntu
  ```
  $ sudo apt update
  $ sudo apt install git automake bison build-essential pkg-config libevent-dev libncurses5-dev
  $ cd /usr/local/src/
  $ # git clone https://github.com/tmux/tmux
  $ # cd ./tmux/
  $ # ./autogen.sh
  $ wget https://github.com/tmux/tmux/releases/download/3.1b/tmux-3.1b.tar.gz
  $ tar -zxf tmux-3.1b.tar.gz
  $ cd tmux-3.1b
  $ ./configure --prefix=/usr/local
  $ make
  $ sudo make install
  ```
- CentOS7
  ```
  # yum groupinstall "Development Tools"
  # yum install libevent ncurses libevent-devel ncurses-devel
  # cd /usr/local/src/
  # # git clone https://github.com/tmux/tmux
  # # cd ./tmux/
  # # ./autogen.sh
  # wget https://github.com/tmux/tmux/releases/download/3.1b/tmux-3.1b.tar.gz
  # tar -zxf tmux-3.1b.tar.gz
  # cd tmux-3.1b
  # ./configure --prefix=/usr/local
  # make
  # make install
  ```
