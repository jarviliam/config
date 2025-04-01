{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    shortcut = "Space";
    shell = "zsh";
    baseIndex = 1;
    terminal = "screen-256color";
    keyMode = "vi";
    historyLimit = 10000;
    escapeTime = 0;
    customPaneNavigationAndResize = true;
    resizeAmount = 5;

    plugins = with pkgs.tmuxPlugins; [
      sensible
      gruvbox
      fzf-tmux-url
      tmux-fzf
      tmux-which-key
    ];

    extraConfig = ''
      set -g status on
      set -g destroy-unattached on
      set -g monitor-activity off
      set -g visual-activity off
      set -g -w automatic-rename on
      set -g renumber-windows on
      set -g bell-action none
      set -g status-position top
      set -g status-interval 5

      set -g @fzf-url-bind 'x'
      bind-key -n M-n new-window -c "#{pane_current_path}"
      bind-key -n M-[ previous-window
      bind-key -n M-] next-window
      bind-key -n M-{ swap-window -t -1\; select-window -t -1
      bind-key -n M-\} swap-window -t +1\; select-window -t +1

      bind-key -n M-1 select-window -t:1
      bind-key -n M-2 select-window -t:2
      bind-key -n M-3 select-window -t:3
      bind-key -n M-4 select-window -t:4
      bind-key -n M-5 select-window -t:5
      bind-key -n M-6 select-window -t:6
      bind-key -n M-7 select-window -t:7
      bind-key -n M-8 select-window -t:8
      bind-key -n M-9 select-window -t:9
      bind-key -n M-0 select-window -t:10

      unbind-key '"'
      unbind-key '%'
      bind-key -n M-- split-window -v -c "#{pane_current_path}"
      bind-key -n M-\\ split-window -h -c "#{pane_current_path}"
      bind-key -n M-_ split-window -fv -c "#{pane_current_path}"
      bind-key -n M-| split-window -fh -c "#{pane_current_path}"

      bind-key -T copy-mode-vi M-H resize-pane -L 1
      bind-key -T copy-mode-vi M-J resize-pane -D 1
      bind-key -T copy-mode-vi M-K resize-pane -U 1
      bind-key -T copy-mode-vi M-L resize-pane -R 1

      bind-key -n M-z resize-pane -Z

      unbind-key '{'
      unbind-key '}'
      bind-key -r H swap-pane -U
      bind-key -r L swap-pane -D

      bind-key -n M-q kill-pane
      bind-key -n M-Q kill-window

      bind-key -r '[' swap-window -t -1
      bind-key -r ']' swap-window -t +1

      unbind-key '&'

      bind-key -n M-y copy-mode
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi V send-keys -X select-line
      bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
      bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "wl-copy"
      bind-key -T copy-mode-vi Enter send-keys -X copy-pipe-and-cancel "wl-copy"
      bind-key -T copy-mode-vi Escape send-keys -X cancel
      unbind-key -T copy-mode-vi MouseDragEnd1Pane
      bind-key -T copy-mode-vi WheelUpPane select-pane \; send-keys -t '{mouse}' -X clear-selection \; send-keys -t '{mouse}' -X -N 5 scroll-up
      bind-key -T copy-mode-vi WheelDownPane select-pane \; send-keys -t '{mouse}' -X clear-selection \; send-keys -t '{mouse}' -X -N 5 scroll-down

      bind-key '/' copy-mode \; send-keys "/"
      bind-key '?' copy-mode \; send-keys "?"

      bind-key -T copy-mode-vi M-h select-pane -L
      bind-key -T copy-mode-vi M-j select-pane -D
      bind-key -T copy-mode-vi M-k select-pane -U
      bind-key -T copy-mode-vi M-l select-pane -R

      is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
          | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
      bind-key -n M-h if-shell "$is_vim" 'send-keys M-h'  'select-pane -L'
      bind-key -n M-j if-shell "$is_vim" 'send-keys M-j'  'select-pane -D'
      bind-key -n M-k if-shell "$is_vim" 'send-keys M-k'  'select-pane -U'
      bind-key -n M-l if-shell "$is_vim" 'send-keys M-l'  'select-pane -R'

      bind-key -n M-H if-shell "$is_vim" 'send-keys M-H' 'resize-pane -L 3'
      bind-key -n M-J if-shell "$is_vim" 'send-keys M-J' 'resize-pane -D 3'
      bind-key -n M-K if-shell "$is_vim" 'send-keys M-K' 'resize-pane -U 3'
      bind-key -n M-L if-shell "$is_vim" 'send-keys M-L' 'resize-pane -R 3'

      tmux_version='$(tmux -V | sed -En "s/^tmux ([0-9]+(.[0-9]+)?).*/\1/p")'
      if-shell -b '[ "$(echo "$tmux_version < 3.0" | bc)" = 1 ]' \
          "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\'  'select-pane -l'"
      if-shell -b '[ "$(echo "$tmux_version >= 3.0" | bc)" = 1 ]' \
          "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\\\'  'select-pane -l'"

      bind-key -T copy-mode-vi 'C-h' select-pane -L
      bind-key -T copy-mode-vi 'C-j' select-pane -D
      bind-key -T copy-mode-vi 'C-k' select-pane -U
      bind-key -T copy-mode-vi 'C-l' select-pane -R
      bind-key -T copy-mode-vi 'C-\' select-pane -l

      set -g @emulate-scroll-for-no-mouse-alternate-buffer "on"
    '';
  };
}
