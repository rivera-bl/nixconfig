# Nix home tools

if not being able to use `.exe` programs:

````bash
sudo sh -c 'echo :WSLInterop:M::MZ::/init:PF > /usr/lib/binfmt.d/WSLInterop.conf'
exit
wsl --shutdown
wsl -d ${distro}
echo "hola" | clip.exe
````

Editor is other repository.
