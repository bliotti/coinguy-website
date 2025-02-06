#!/bin/bash

set -v
### INSTALL COMMAND
### /bin/bash -c "$(curl -fsSL https://coinguy.io/install.sh)"

# Check for Zsh installation, install if not present
if ! command -v zsh &>/dev/null; then
  echo "Zsh is not installed. Installing Zsh..."
  if [ "$(uname)" == "Darwin" ]; then
    # macOS installation
    brew install zsh
  elif [ -f /etc/debian_version ]; then
    # Debian/Ubuntu installation
    sudo apt update && sudo apt install -y zsh
  elif [ -f /etc/redhat-release ]; then
    # RHEL/Fedora/CentOS installation
    sudo yum install -y zsh
  else
    echo "Unsupported OS. Please install Zsh manually."
    exit 1
  fi
fi

# Verify Zsh was installed correctly
if ! command -v zsh &>/dev/null; then
  echo "Failed to install Zsh. Please install it manually."
  exit 1
fi

echo "Zsh is installed."

# Check for Git installation, install if not present
if ! command -v git &>/dev/null; then
  echo "Git is not installed. Installing Git..."
  if [ "$(uname)" == "Darwin" ]; then
    # macOS installation
    brew install git
  elif [ -f /etc/debian_version ]; then
    # Debian/Ubuntu installation
    sudo apt update && sudo apt install -y git
  elif [ -f /etc/redhat-release ]; then
    # RHEL/Fedora/CentOS installation
    sudo yum install -y git
  else
    echo "Unsupported OS. Please install Git manually."
    exit 1
  fi
fi

# Verify Git was installed correctly
if ! command -v git &>/dev/null; then
  echo "Failed to install Git. Please install it manually."
  exit 1
fi

echo "Git is installed."

# Install Oh My Zsh without launching a new shell
RUNZSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}

# INSTALL PLUGINS
# zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions

# zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting

# zsh-fast-syntax-highlighting
git clone https://github.com/zdharma-continuum/fast-syntax-highlighting.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/fast-syntax-highlighting

# zsh-completions
git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions

## zsh-autocomplete
# git clone --depth 1 -- https://github.com/marlonrichert/zsh-autocomplete.git $ZSH_CUSTOM/plugins/zsh-autocomplete


# K
git clone https://github.com/supercrabtree/k $ZSH_CUSTOM/plugins/k

## OPTIONAL PLUGINS
## powerlevel10k
# git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
## zsh-history-substring-search 
# git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search  

# Theme
git clone https://github.com/ChesterYue/ohmyzsh-theme-passion
cp ./ohmyzsh-theme-passion/passion.zsh-theme ~/.oh-my-zsh/themes/passion.zsh-theme

# Define the .zshrc file location (you can adjust this path if needed)
ZSHRC_FILE="$HOME/.zshrc"

# Use sed to find and replace the plugins line and theme line
sed -i.bak -e '/^plugins=(/c\
plugins=(\
  git\
  k\
  zsh-autosuggestions\
  zsh-syntax-highlighting\
  fast-syntax-highlighting\
)' -e '/^ZSH_THEME=/c\
ZSH_THEME="passion"' -e "s|fpath+=\${ZSH_CUSTOM:-\${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src|fpath+=\${ZSH_CUSTOM:-\${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src|" "$HOME/.zshrc"


# Inform the user
echo "The plugins line has been updated in $ZSHRC_FILE. A backup has been created as $ZSHRC_FILE.bak."

# ZSH_THEME="powerlevel10k/powerlevel10k"' "$HOME/.zshrc"

# Inform the user
echo "The plugins line has been updated in $ZSHRC_FILE. A backup has been created as $ZSHRC_FILE.bak."

# Automatically change default shell to Zsh without prompting
if [ "$SHELL" != "$(which zsh)" ]; then
  echo "Changing your default shell to Zsh..."
  chsh -s "$(which zsh)" "$USER"
  echo "Default shell changed to Zsh. Please restart your terminal or log out and log back in."
fi

set +v

# Prompt the user to switch to Zsh manually
echo "Installation complete! Please run 'zsh' to switch to Zsh and load your updated configuration."
