---
name: dotfiles-setup
description: 在新机器（macOS 或 Linux，包括没有 root 的旧 HPC 服务器）上部署或更新这个 dotfiles 仓库，并排查终端配色、真彩色、tmux、ls 颜色、fish 等环境问题。用户说"设置这台机器""装 dotfiles""配置环境"或报告终端显示异常时使用。
---

# 用这个仓库配置一台机器

这个仓库是用户的个人配置。所有机器的登录 shell 都是 bash：`bash_profile` 设置好环境变量（PATH、EDITOR、LANG），再把交互会话交给 fish。配色统一用 Ghostty 的 Dayfox 浅色主题。`init.sh` 负责链接配置和安装软件，这份说明负责判断机器情况、选择安装方式和排查问题。

## 必须遵守

- **任何安装都先征得用户同意。** 先列出要装什么、用什么方式、装到哪里，等用户确认后再执行。用 `tic` 往 `~/.terminfo` 写终端描述也算安装。建立链接、读取信息不需要逐项确认，但开始前要说明计划。
- 覆盖已有文件前先备份。`create_symlink` 会自动把原文件（包括指向别处的旧链接）移到 `~/.dotfiles_backup/`；手动改文件时，先复制一份 `文件.bak-日期`。
- 登录 shell：Linux 上不改（不用 `chsh`）；macOS 默认是 zsh，必须改成 bash，`bash_profile` 才会执行。这一步由 `setup_brew_bash` 完成，它会先询问。
- 机器专用的设置不进仓库，模板在 `examples/`：`~/.bashrc`（`/etc/bashrc`、`module load`）、`~/.config/fish.local.fish`（这台机器的别名、函数）、`~/.gitconfig.local`（git 身份）。
- 修改仓库里的代码时，注释一律用英文，只写原因，不逐行解释在做什么。
- 需要用户自己运行的命令，机器上有 fish 时用 fish 语法写，没有时用 bash 语法。
- 汇报时分清哪些已经验证、哪些只是推断。不要擅自 commit 或 push。

## 仓库结构

| 仓库里的文件 | 链接到 | 适用 |
|---|---|---|
| `bash_profile` | `~/.bash_profile` | 都用。PATH、EDITOR、LANG 都在这里设置；然后读取 `~/.bashrc`，交互时 `exec fish` |
| `gitconfig` | `~/.gitconfig` | 都用。身份信息在 `~/.gitconfig.local` |
| `config/fish/` | `~/.config/fish` | 都用。只放 fish 自己的东西（别名、补全、提示符），不设环境变量 |
| `config/fish/conf.d/ls_colors.fish` | （随 fish 目录） | 都用。真彩色 `LS_COLORS`；macOS 上有 `gls` 时用它代替 BSD ls |
| `config/tmux/tmux.conf` | `~/.tmux.conf` | 都用。按 tmux 2.7 的能力写 |
| `vimrc` | `~/.vimrc` | 都用。没有 nvim 的机器靠它 |
| `config/starship.toml` | `~/.config/starship.toml` | 都链接，只在装了 starship 的机器上生效 |
| `config/ghostty`、`config/nvim` | 对应位置 | 只在 macOS 上链接。Linux 上有 nvim 时才询问是否链接 nvim |
| `Brewfile`、`Brewfile.extra` | — | macOS 的基础软件和可选软件 |
| `examples/` | — | 上面三个机器专用文件的模板，分 macOS 和 Linux 两部分 |

`init.sh` 可以整体运行（`./init.sh`，交互式），也可以只加载函数、在子 shell 里单独执行某一步。不要在自己正在用的 shell 里 `source` 它。

```bash
bash -c 'source ~/dotfiles/init.sh; set -euo pipefail; link_configs'
bash -c 'source ~/dotfiles/init.sh; set -euo pipefail; install_static_tool fish'
```

不读键盘、可以直接调用的函数：`link_configs`（只建链接，包括迁移旧的 `local.fish`）、`install_with_package_manager <pm> <工具...>`、`link_debian_names`、`install_static_tool <工具>`、`check_terminfo`。会读键盘的是 `confirm`、`setup_git_identity`、`setup_brew_bash` 和整个 `main`：先在对话里问用户，再调用上面那些函数；git 身份可以直接用 `git config --file ~/.gitconfig.local user.name ...` 写入。

## 步骤

### 1. 把仓库放到目标机器上

有 git、改动已经 push 时，直接 `git clone` 到 `~/dotfiles`。机器上没有 git，或者用户本地有未提交的改动时，从 Mac 复制工作区：

```bash
COPYFILE_DISABLE=1 tar --no-xattrs -C ~/dotfiles --exclude .git --exclude .DS_Store -cf - . | ssh <host> 'mkdir -p ~/dotfiles && tar -C ~/dotfiles -xf -'
```

`COPYFILE_DISABLE=1` 防止 macOS 的 tar 带出一批 `._*` 文件，`--no-xattrs` 让 Linux 的 tar 不再逐个提示忽略 macOS 的扩展属性。复制过去的仓库没有 git 历史，以后要更新还是得装 git 再 clone。

### 2. 了解机器情况（只读）

```bash
uname -sm; cat /etc/os-release 2>/dev/null | head -3; ldd --version 2>/dev/null | head -1
command -v sudo apt-get dnf yum pacman zypper brew module 2>/dev/null
for c in git fish tmux vim nvim rg fd fdfind bat batcat starship gls claude; do printf '%-9s %s\n' $c "$(command -v $c)"; done
fish --version 2>/dev/null; tmux -V 2>/dev/null; vim --version 2>/dev/null | head -1
df -hT ~ | tail -1        # 家目录是否在 Lustre / NFS 等网络文件系统上
infocmp xterm-ghostty >/dev/null 2>&1 && echo "xterm-ghostty ok" || echo "xterm-ghostty missing"
locale -a | grep -iE '^(en_US|C)\.utf-?8$'
ls -la ~/.bash_profile ~/.bashrc ~/.profile ~/.config/fish ~/.tmux.conf ~/.vimrc ~/.gitconfig 2>&1
```

注意几点：
- 通过 `ssh host '命令'` 执行时 `TERM=dumb`，所以 terminfo 要按名字查 `xterm-ghostty`，不能查 `$TERM`。
- `sudo` 存在不代表有权限。可以用 `sudo -n true` 测试是否免密码，它不会改动任何东西。如果需要密码，`ssh -o BatchMode=yes` 没法输入，要把命令交给用户自己运行。
- 在 Debian/Ubuntu 上，有了 `~/.bash_profile` 之后 bash 登录时不再读 `~/.profile`。如果 `~/.profile` 被改过，要把里面的设置挪到 `~/.bashrc`，并告诉用户。

### 3. 判断机器类型，选择安装方式

- **macOS**：用 Homebrew，先装 `Brewfile`，`Brewfile.extra` 按用户意愿装。LS_COLORS 需要 GNU ls，所以要有 `coreutils`（已在 Brewfile 里）。
- **普通 Linux（有 root，有包管理器）**：用一条包管理器命令装齐 `git fish tmux ripgrep fd bat`。Debian/Ubuntu 上 fd、bat 的命令名是 `fdfind`、`batcat`，`link_debian_names` 会在 `~/.local/bin` 里建好同名链接。RHEL 系需要先启用 EPEL。配置要求 fish 3.1 以上，系统自带的版本太旧时改用静态版。
- **受限 Linux（没有 root、glibc 旧，典型是 HPC 登录节点）**：把单文件程序装到 `~/.local/bin`（`install_static_tool`）。fish 用官方静态版；rg、fd、bat 用 musl 版，不依赖系统 glibc。版本号写在 `init.sh` 开头。git 和 tmux 用系统自带的。
  - starship 在 Linux 上是可选项：`init.sh` 会单独询问，装的是 musl 静态版（`install_static_tool starship`），不装就用 fish 自带的提示符。家目录在网络文件系统上时，不建议装 starship（每次显示提示符都要查 git 状态）和 AstroNvim（插件多、小文件多、配额小）。用 vim 和 `vimrc` 就够了。真的需要 nvim 时，glibc 2.28 这类旧系统要用 `neovim/neovim-releases` 仓库提供的 glibc 2.17 版本，并为它写一份不带插件的轻量配置。
  - `module load` 放在 `~/.bashrc` 里，加载后的环境变量会被 fish 继承。但 `module` 命令本身是 bash 函数，fish 里要用的话，需要在 `fish.local.fish` 里 source `$MODULESHOME/init/fish`（见 `examples/fish.local.fish`）。
  - 已有的 `~/.bashrc` 里如果有 `exec fish`，要删掉（先问用户）：`bash_profile` 已经负责切换，而旧代码没有排除 `bash -ilc 命令` 这种调用，会把命令吞掉。

### 4. 和用户确认计划，然后执行

把要链接的文件、要安装的软件（名称、方式、位置）、要写的机器专用文件列给用户，确认后再做。替换已有的 `~/.config/fish` 时，`link_configs` 会把里面的 `local.fish` 移到 `~/.config/fish.local.fish`，把 `fish_variables` 留在新目录里；旧目录里的 `functions/`、`completions/` 等文件不会迁移，脚本会列出来，要和用户确认是否需要。

Claude Code 的自动模式可能会拦截“从网上下载并执行”的命令。被拦截时，把命令整理好交给用户自己运行，不要换一种写法绕过去。

### 5. 验证

都在**新开的终端**里检查。已经打开的 shell 和 tmux server 不会读到新配置，必要时执行 `tmux kill-server`，执行前先问用户。

```bash
echo $EDITOR $LANG                   # 由 bash_profile 设置
echo $COLORTERM                      # tmux 里应为 truecolor
tmux info | grep Tc                  # 应为 Tc: (flag) true
echo $LS_COLORS | cut -c1-40         # tmux 里外都应以 rs=0:mh=0:ca=0:di=1;38;2;40;72;169 开头
```

真彩色测试：在 tmux 里外各运行一次，两边的渐变效果应该一样。每格颜色不同，所以即使真彩色正常，也能看到轻微的分段。

```bash
awk 'BEGIN{for(i=0;i<77;i++){r=255-i*255/76;g=i*510/76;if(g>255)g=510-g;b=i*255/76;printf "\033[48;2;%d;%d;%dm \033[0m",r,g,b}print ""}'
```

## 已知问题

| 现象 | 原因 | 处理 |
|---|---|---|
| tmux 报 `invalid option: terminal-features` | 这个选项从 tmux 3.2 才有 | 仓库的 tmux.conf 已改用 `terminal-overrides ... :Tc`，新旧版本都支持 |
| tmux 里颜色发灰、渐变和外面不一样 | tmux 没有启用真彩色，或者 tmux 里的程序不知道可以用真彩色 | 需要 `Tc` 和 `COLORTERM` 两项设置，然后 `kill-server` 重开。只 `source-file` 不会生效 |
| Claude Code 的标志在 tmux 里偏粉、偏淡 | Claude Code 检测到 `$TMUX` 后会主动降到 256 色 | tmux.conf 里设置了 `CLAUDE_CODE_TMUX_TRUECOLOR=1`。这个变量不在官方文档里，是从 2.1.308 版程序里找到的。如果升级后又出现，用 `strings "$(readlink -f "$(command -v claude)")" \| grep -o 'CLAUDE_CODE_TMUX_[A-Z_]*'` 查一下变量名有没有变 |
| tmux 里外 `ls` 颜色不同 | RHEL 系的 `/etc/profile.d/colorls.sh` 会按 `$TERM` 选择配色文件，`xterm-ghostty` 匹配不上，`tmux-256color` 能匹配上 | `conf.d/ls_colors.fish` 会在 fish 里覆盖 `LS_COLORS`，不用改系统文件 |
| macOS 上 `ls` 不显示 LS_COLORS 配色 | BSD ls 只读 `LSCOLORS` | 安装 coreutils，`ls_colors.fish` 会自动改用 `gls` |
| 登录服务器后提示 `xterm-ghostty: unknown terminal` | 服务器没有 Ghostty 的终端描述。Debian 的 ncurses-term 只带 `ghostty`，没有 `xterm-ghostty` | 在 Mac 上执行 `infocmp -x xterm-ghostty \| ssh <host> -- tic -x -`，会装到服务器的 `~/.terminfo`，不需要 root。这条命令要在 Ghostty 里运行：Mac 自带的 ncurses 没有这个条目，是 Ghostty 设置的 `TERMINFO` 提供的 |
| perl、python 报 `Setting locale failed` | 机器上没有 en_US.UTF-8（Debian 云镜像只有 C.UTF-8） | `bash_profile` 会自动退回 C.UTF-8。想要 en_US.UTF-8 的话，需要 root 打开 `/etc/locale.gen` 里那一行再运行 `locale-gen` |
| vim 开启 `termguicolors` 后颜色全部消失 | vim 8.0 在这些 `TERM` 下不会自动设置 `t_8f`/`t_8b` | `vimrc` 里已经手动设置 |
| fish 函数里的 `rm *.job.e*` 在没有匹配文件时报错 | fish 的通配符匹配不到文件时会报错，bash 不会 | 先 `set -l files ...`，再用 `test (count $files) -gt 0` 判断 |

## 从 Mac 操作服务器

如果服务器登录需要密码加一次性验证码，可以在 Mac 的 `~/.ssh/config` 里给它设置 `ControlMaster auto`、`ControlPersist yes` 和 `ServerAliveInterval 60`。用户手动登录一次后，你就可以用 `ssh -o BatchMode=yes <host> '...'` 复用这条连接执行命令。
