curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
nix-channel --add https://nixos.org/channels/nixpkgs-unstable unstable
nix-channel --update
nix-channel --list
nix-channel --add https://github.com/nix-community/home-manager/archive/master.tar.gz home-manager

git clone https://github.com/Fantasy-programming/dotfiles.git
ln -s ~/dotfiles home-manager
