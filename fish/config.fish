if status is-interactive
    # Commands to run in interactive sessions can go here
    set -g fish_key_bindings fish_vi_key_bindings
end

function fish_greeting
    ~/programavimas/scripts/top_status.bash
    echo
end

function multicd
    echo cd (string repeat -n (math (string length -- $argv[1]) - 1) ../)
end

function quick_exec
    set cmd (echo $argv[1] | cut -c 3-)
    command $cmd
end

abbr -a ":g" --position anywhere --set-cursor " | rg \"%\""
abbr -a ":s" --position anywhere --set-cursor " | sed \"s/%\""
abbr -a ":a" --position anywhere --set-cursor " | awk '{ print \$% }'"
abbr -a dotdot --regex '^\.\.+$' --function multicd
abbr -a :place --function linuxquote --position anywhere
abbr -a inline_command --position anywhere --regex ':!(.*?)' --function quick_exec
abbr -a n nvim
# abbr -a xin sudo xbps-install
# abbr -a xup sudo xbps-install -Su
# abbr -a xfi xbps-query -Rs
abbr -a gd git diff
abbr -a gp git push
abbr -a ga "git add ."
abbr -a --set-cursor=% gc "git commit -m \"%\""
abbr -a --set-cursor=% gcf "git commit -m \"feat: %\""
abbr -a --set-cursor=% gct "git commit -m \"test: %\""
abbr -a --set-cursor=% gcx "git commit -m \"fix: %\""
abbr -a --set-cursor=% gcx "git commit -m \"style: %\""
abbr -a --set-cursor=% gcr "git commit -m \"refactor: %\""
