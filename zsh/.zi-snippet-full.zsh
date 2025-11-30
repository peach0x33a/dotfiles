
### 初始部分-开始

# Code Stats 统计插件
# 已启用条件加载
zi lucid wait'1' for \
    depth"1" \
    if'[ ! -z ${CODESTATS_API_KEY} ]' \
    from"gitlab.com" \
    code-stats/code-stats-zsh

zi lucid wait'1' for \
    from"hub.scgit.top" \
    z-shell/zui

# fzf 补全和绑定
zi lucid wait'1' has"fzf" for \
    depth"1" \
    multisrc"plugins/fzf/*.zsh" \
    pick"/dev/null" \
    from"hub.scgit.top" \
    ohmyzsh/ohmyzsh

# OMZ 框架
necessary_omz_libs=(
    lib/completion.zsh
    lib/history.zsh
    lib/key-bindings.zsh
    lib/theme-and-appearance.zsh
    lib/directories.zsh
    lib/functions.zsh
    lib/git.zsh
    lib/grep.zsh
    lib/compfix.zsh
    lib/termsupport.zsh
    lib/nvm.zsh
    lib/misc.zsh
)

zi lucid for \
    depth"1" \
    multisrc"$necessary_omz_libs" \
    pick"/dev/null" \
    from"hub.scgit.top" \
    ohmyzsh/ohmyzsh

# fzf-tab fzf 增强
zi wait'1' lucid has"fzf" for \
    depth"1" \
    from"hub.scgit.top" \
    Aloxaf/fzf-tab

# fzf 额外配置
# 列出目录
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath' # remember to use single quote here!!!
# 显示 Systemd 服务状态
zstyle ':fzf-tab:complete:systemctl-*:*' fzf-preview 'SYSTEMD_COLORS=1 systemctl status $word'

zi wait'1' lucid for \
    depth"1" \
    from"hub.scgit.top" \
    atload"_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions

# 另一款比较好看的主题是 free 其他都一般般
# export $FAST_THEME_NAME="default"
zi wait'1' lucid for \
    depth=1 \
    from"hub.scgit.top" \
    atinit"zicompinit; zicdreplay" \
    atpull"cp share/free_theme.zsh ${FAST_WORK_DIR:-${XDG_CACHE_HOME:-~/.cache}/f-sy-h}/secondary_theme.zsh"\
    atload'fast-theme default &>/dev/null;' \
    z-shell/F-Sy-H

# zi wait'1' lucid for \
#     depth"1" \
#     from"hub.scgit.top" \
#     atpull'zi creinstall -q .' \
#     pick'/dev/null' \
#     blockf \
#     zsh-users/zsh-completions

# atinit'AUTOCD=1' 可以在进入目录时自动列出文件
zi lucid wait'1' has'exa' for \
    depth"1" \
    from"hub.scgit.top" \
    zplugin/zsh-exa

# 对于较新的系统应当加载 eza
zi lucid wait'1' has'eza' for \
    depth"1" \
    from"hub.scgit.top" \
    z-shell/zsh-eza

# zoxide 快速目录跳转
# zi 缩写有冲突,要用 z-shell 维护的版本
zi lucid wait'1' has"zoxide" for \
    depth"1" \
    from"hub.scgit.top" \
    atclone"git submodule set-url zoxide https://hub.scgit.top/ajeetdsouza/zoxide" \
    z-shell/zsh-zoxide

zi wait'1' lucid for \
    depth"1" \
    from"hub.scgit.top" \
    z-shell/zi-console

zi wait'1' lucid for \
    depth"1" \
    from"hub.scgit.top" \
    MichaelAquilina/zsh-you-should-use

### 初始部分-结束### 别名-开始

alias freshZshCache="source ~/.zshrc"
# sudo 保留别名
# alias sudo='sudo '
# sudo 保留变量
# alias sudo='sudo -E'
### 别名-结束
### Java-开始

if [ -e "${SDKMAN_DIR}/bin/sdkman-init.sh" ];then
    source "${SDKMAN_DIR}/bin/sdkman-init.sh"
fi

# 加载 SDKMAN 插件
zi lucid wait'1' for \
    depth"1" \
    from"hub.scgit.top" \
    if'[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]' \
    matthieusb/zsh-sdkman

# 加载 Gradle
zi lucid wait'1' has"java" for \
    multisrc"plugins/gradle/*.zsh" \
    pick"/dev/null" \
    from"hub.scgit.top" \
    ohmyzsh/ohmyzsh

### Java-结束### PHP-开始

# 加载 DDEV
zi lucid wait'1' has"ddev" for \
    id-as"ddev_completion" \
    from"hub.scgit.top" \
    as"completion" \
    atclone"ddev completion zsh > _ddev; zinit creinstall -q ddev_completion" \
    atpull"%atclone" \
    run-atpull \
    z-shell/null
### PHP-结束### Rust-开始

# 尝试加载 Rustup
if [ -s "$HOME/.cargo/bin/rustup" ]; then
    source ~/.cargo/env
    export RUST_SYSROOT=$(rustc --print sysroot)
fi

# rustup 补全
zi lucid wait'1' has"rustup" for \
    id-as"rustup_completion" \
    from"hub.scgit.top" \
    as"completion" \
    atclone"rustup completions zsh > _rustup; zinit creinstall -q rustup_completion" \
    atpull"%atclone" \
    run-atpull \
    z-shell/null


# cargo 补全 注意还是从 rustup 加载的
zi lucid wait'1' has"rustup" for \
    id-as"cargo_completion" \
    from"hub.scgit.top" \
    as"completion" \
    atclone"cat $RUST_SYSROOT/share/zsh/site-functions/_cargo >> _cargo; zinit creinstall -q cargo_completion" \
    atpull"%atclone" \
    run-atpull \
    z-shell/null

# 设置一些默认参数
zi default-ice -q lucid depth=1 from"hub.scgit.top"

# zi lucid wait'1' has"rustup" for \
#     @rust-utils

zi default-ice -cq
### Rust-结束### Ruby-开始

# RVM
# 首先是加载 RVM
# [[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"
# 然后加载插件,需要注意这里有一个加载补全要用 zpcdreplay 解决一下
# zi lucid wait'1' has"rvm" for \
#     from"hub.scgit.top" \
#     atload"export PATH="$PATH:$HOME/.rvm/bin"" \
#     atload"zpcdreplay" \
#     multisrc"plugins/rvm/*.zsh" \
#     pick"/dev/null" \
#     from"hub.scgit.top" \
#     ohmyzsh/ohmyzsh

# Ruby 一些别名,意义不大
# zi lucid wait'1' has"ruby" for \
#     from"hub.scgit.top" \
#     OMZP::ruby

### Ruby-结束
### 容器部分-开始

# 来自 Docker 官方的补全
# 测试对 docker compose 也有效
zi lucid wait'1' has"docker" for \
    id-as"docker_completion" \
    from"hub.scgit.top" \
    as"completion" \
    atclone"docker completion zsh > _docker; zinit creinstall -q docker_completion" \
    atpull"%atclone" \
    run-atpull \
    z-shell/null

# 允许对堆叠进行补全
zstyle ':completion:*:*:docker:*' option-stacking yes
zstyle ':completion:*:*:docker-*:*' option-stacking yes

### 容器部分-结束### K8S 官方仓库的命令部分-开始

# kubectl 插件与补全
zi lucid wait'1' has"kubectl" for \
    id-as"kubectl_completion" \
    from"hub.scgit.top" \
    as"completion" \
    atclone"kubectl completion zsh > _kubectl; zinit creinstall -q kubectl_completion" \
    atpull"%atclone" \
    run-atpull \
    z-shell/null

# 加载 Kubeadm
zi lucid wait'1' has"kubeadm" for \
    id-as"kubeadm_completion" \
    from"hub.scgit.top" \
    as"completion" \
    atclone"kubeadm completion zsh > _kubeadm; zinit creinstall -q kubeadm_completion" \
    atpull"%atclone" \
    run-atpull \
    z-shell/null

# 加载 minikube
zi lucid wait'1' has"minikube" for \
    id-as"minikube_completion" \
    from"hub.scgit.top" \
    as"completion" \
    atclone"minikube completion zsh > _minikube; zinit creinstall -q minikube_completion" \
    atpull"%atclone" \
    run-atpull \
    z-shell/null
### K8S 官方仓库的命令部分-结束

### K8S 其他相关命令部分-开始

# Cilium
zi lucid wait'1' has"cilium" for \
    id-as"cilium_completion" \
    from"hub.scgit.top" \
    as"completion" \
    atclone"cilium completion zsh > _cilium; zinit creinstall -q cilium_completion" \
    atpull"%atclone" \
    run-atpull \
    z-shell/null

# 加载 helm
zi lucid wait'1' has"helm" for \
    id-as"helm_completion" \
    from"hub.scgit.top" \
    as"completion" \
    atclone"helm completion zsh > _helm; zinit creinstall -q helm_completion" \
    atpull"%atclone" \
    run-atpull \
    z-shell/null

# 加载 istioctl
zi lucid wait'1' has"istioctl" for \
    id-as"istioctl_completion" \
    from"hub.scgit.top" \
    as"completion" \
    atclone"istioctl completion zsh > _istioctl; zinit creinstall -q istioctl_completion" \
    atpull"%atclone" \
    run-atpull \
    z-shell/null

### K8S 其他相关命令部分-结束

### Krew 插件-开始

# 这里的补全不仅是补全,还要做软链接和补全别名定义.

# kubecm 多集群配置管理工具
zi lucid wait'1' has"kubectl-kc" for \
    id-as"kubecm_completion" \
    from"hub.scgit.top" \
    as"completion" \
    atclone"kubectl-kc completion zsh > _kubecm; zinit creinstall -q kubecm_completion" \
    atinit"ln -sf $HOME/.krew/bin/kubectl-kc $ZPFX/bin/kubecm;
    compdef _kubecm kubectl-kc;
    echo '#!/bin/sh\nkubectl-kc __complete \"\$@\"' > $HOME/.krew/bin/kubectl_complete-kc;
    chmod +x $HOME/.krew/bin/kubectl_complete-kc" \
    atpull"%atclone" \
    run-atpull \
    z-shell/null

# Krew kubectl 插件管理器
zi lucid wait'1' has"kubectl-krew" for \
    id-as"krew_completion" \
    from"hub.scgit.top" \
    as"completion" \
    atclone"kubectl-krew completion zsh > _krew; zinit creinstall -q krew_completion" \
    atinit"ln -sf $HOME/.krew/bin/kubectl-krew $ZPFX/bin/krew;compdef _krew kubectl-krew;
    echo '#!/bin/sh\nkubectl-krew __complete \"\$@\"' > $HOME/.krew/bin/kubectl_complete-krew;
    chmod +x $HOME/.krew/bin/kubectl_complete-krew" \
    atpull"%atclone" \
    run-atpull \
    z-shell/null
### Krew 插件-结束

## 其他 K8S 开发工具-开始

zi lucid wait'1' has"operator-sdk" for \
    id-as"operator-sdk_completion" \
    from"hub.scgit.top" \
    as"completion" \
    atclone"operator-sdk completion zsh > _operator-sdk; zinit creinstall -q operator-sdk_completion" \
    atpull"%atclone" \
    run-atpull \
    z-shell/null

## 其他 K8S 开发工具-结束### Git-开始

# 加载 Git 插件

# GitIgnore
zi lucid wait"1" has"git" for \
    depth=1 \
    from"hub.scgit.top" \
    atclone"git submodule set-url templates https://hub.scgit.top/github/gitignore.git" \
    voronkovich/gitignore.plugin.zsh

omz_git_plugins=(
    plugins/git/\*.zsh
    plugins/git-auto-fetch/\*.zsh
    plugins/git-extras/\*.zsh
    plugins/git-flow/\*.zsh
    plugins/gitignore/\*.zsh
)
# gf 用的少还跟 GoFrame 冲突, 所以不用
zi lucid wait'1' has"git" for \
    multisrc"$omz_git_plugins" \
    pick"/dev/null" \
    atload'unalias gf' \
    from"hub.scgit.top" \
    ohmyzsh/ohmyzsh

# 高级 Diff
zi lucid wait'1' has"diff-so-fancy" for \
    depth"1" \
    from"hub.scgit.top" \
    null \
    sbin'bin/git-dsf;bin/diff-so-fancy;bin/fancy-diff;' \
    z-shell/zsh-diff-so-fancy
### Git-结束
### OMZ 精选插件-开始

# 加载 thefuck
zi lucid wait'1' has"thefuck" for \
    multisrc"plugins/thefuck/*.zsh" \
    pick"/dev/null" \
    from"hub.scgit.top" \
    ohmyzsh/ohmyzsh

# 加载 pip
zi lucid wait'1' has"pip" for \
    multisrc"plugins/pip/*.zsh" \
    pick"/dev/null" \
    from"hub.scgit.top" \
    ohmyzsh/ohmyzsh \
    as"completion" \
    multisrc"plugins/pip/_*" \
    pick"/dev/null" \
    from"hub.scgit.top" \
    ohmyzsh/ohmyzsh

# 加载 sudo
zi lucid wait'1' has"sudo" for \
    multisrc"plugins/sudo/*.zsh" \
    pick"/dev/null" \
    from"hub.scgit.top" \
    ohmyzsh/ohmyzsh

# 加载 colored-man-pages
zi lucid wait'1' has"man" for \
    multisrc"plugins/colored-man-pages/*.zsh" \
    pick"/dev/null" \
    from"hub.scgit.top" \
    ohmyzsh/ohmyzsh

# 加载 autojump
zi lucid wait'1' has"autojump" for \
    multisrc"plugins/autojump/*.zsh" \
    pick"/dev/null" \
    from"hub.scgit.top" \
    ohmyzsh/ohmyzsh

# 加载 command-not-found
zi lucid wait'1' for \
    multisrc"plugins/command-not-found/*.zsh" \
    pick"/dev/null" \
    from"hub.scgit.top" \
    ohmyzsh/ohmyzsh

# 解压插件
# zi lucid wait'1' for \
#     multisrc"plugins/extract/*.zsh" \
#     pick"/dev/null" \
#     from"hub.scgit.top" \
#     ohmyzsh/ohmyzsh

# Homebrew
# zi lucid wait'1' has"brew" for \
#     multisrc"plugins/brew/*.zsh" \
#     pick"/dev/null" \
#     from"hub.scgit.top" \
#     ohmyzsh/ohmyzsh

### OMZ 精选插件-结束### 一些杂项-开始

zi lucid wait'1' has"hugo" for \
    id-as"hugo-completion" \
    from"hub.scgit.top" \
    as"completion" \
    atclone"hugo gen autocomplete -t zsh > _hugo" \
    atpull"%atclone" \
    run-atpull \
    nocompile \
    zdharma-continuum/null

# Navi 速查表工具
# zi lucid wait has"navi" for \
#     id-as"hugo-completion" \
#     as"completion" \
#     atclone"navi widget zsh > _navi" \
#     atpull"%atclone" \
#     run-atpull \
#         zdharma-continuum/null
# 检测 navi 命令是否存在
# if [ -x "$(command -v navi)" ]; then
#     eval "$(navi widget zsh)"
# fi

# Just 快速命令工具
zi lucid wait'1' has"just" for \
    id-as"just_completion" \
    from"hub.scgit.top" \
    as"completion" \
    atclone"just --completions zsh > _just; zi creinstall -q just_completion" \
    atpull"%atclone" \
    run-atpull \
    z-shell/null

# if [ -x "$(command -v navi)" ]; then
#     alias j=just
#     alias .j='just --justfile ~/.user.justfile --working-directory .'
# fi

# CoSign 通用签名工具
zi lucid wait'1' has"cosign" for \
    id-as"cosign_completion" \
    from"hub.scgit.top" \
    as"completion" \
    atclone"cosign completion zsh > _cosign; zi creinstall -q cosign_completion" \
    atpull"%atclone" \
    run-atpull \
    z-shell/null


# proto 单一的工具版本管理器
zi lucid wait'1' has"proto" for \
    id-as"proto_completion" \
    from"hub.scgit.top" \
    as"completion" \
    atclone"proto completions --shell zsh > _proto; zi creinstall -q proto_completion" \
    atpull"%atclone" \
    run-atpull \
    z-shell/null
### 一些杂项-结束### NodeJS-开始
# Yarn
# 但是不加载 Yarn 的补全
# zi lucid wait'1' for \
#     wait'[[ $(command -v yarn) ]]' \
#     multisrc"plugins/yarn/*.zsh" \
#     pick"/dev/null" \
#     from"hub.scgit.top" \
#     ohmyzsh/ohmyzsh

# Yarn自动完成
# zi lucid wait"1" for \
#     wait'[[ $(command -v yarn) ]]' \
#     depth"1" \
#     atload"zpcdreplay" \
#     atclone'./zplug.zsh' \
#     from"hub.scgit.top" \
#     g-plane/zsh-yarn-autocompletions

# Volta
zi lucid for \
    if'[ -s "$HOME/.volta" ]' \
    depth"1" \
    from"hub.scgit.top" \
    cowboyd/zsh-volta

zi lucid wait'1' has"volta" for \
    id-as"volta_completion" \
    from"hub.scgit.top" \
    as"completion" \
    atclone"volta completions zsh > _volta; zinit creinstall -q volta_completion" \
    atpull"%atclone" \
    run-atpull \
    nocompile \
    z-shell/null
### NodeJS-结束### 收尾-开始
# Fuzzy matching of completions for when you mistype them:
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle -e ':completion:*:approximate:*' max-errors 'reply=($((($#PREFIX+$#SUFFIX)/3>7?7:($#PREFIX+$#SUFFIX)/3))numeric)'

# Pretty completions
zstyle ':completion:*:matches' group 'yes'
zstyle ':completion:*:options' description 'yes'
zstyle ':completion:*:options' auto-description '%d'
zstyle ':completion:*:corrections' format ' %F{green}-- %d (errors: %e) --%f'
zstyle ':completion:*:descriptions' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*:messages' format ' %F{purple} -- %d --%f'
zstyle ':completion:*:warnings' format ' %F{red}-- no matches found --%f'
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
zstyle ':completion:*' format ' %F{yellow}-- %d --%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*:functions' ignored-patterns '(_*|pre(cmd|exec))'
zstyle ':completion:*' use-cache true
zstyle ':completion:*' rehash true

zi wait lucid atload"zicompinit; zicdreplay" blockf for \
    depth"1" \
    from"hub.scgit.top" \
    zsh-users/zsh-completions
### 收尾-结束
