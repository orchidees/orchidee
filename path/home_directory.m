function homedir = home_directory()

% Return the full name of current user's home directory.
%
% Usage: homedir = home_directory()
%

[st,res] = unix('echo $HOME');
res = res(1:length(res)-1);
homedir = res;