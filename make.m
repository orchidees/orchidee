function make(varargin)

% MAKE - Makefile for the MCC Matlab-compiled Orchidee
% release. Orchidee is compiled without de Java Virtual Machine (so
% forget about displays!)
%
% Usage: make -> Compile Orchidee in the current dir
%        make clean -> Remove all files created by make
%        make path -> add Orchidee directoies to Matlab path
%        make -r -> create a release directoy 'r' with compiled
%                   files only
%
% COMPILATION PROCEDURE
%
% 0. Make sure the orchidee_version.m file is up to date
% 1. Exit Matlab and start a new session
% 2. Change dir to sources dir
% 3. Type 'make -r' in the Matlab shell
% 4. Lauch a Terminal and change dir to 'r' dir
% 5. Run the compiled Orchidee with the following command:
%      ./run_orchidee.sh [path_of_the_v76intel_matlab_mcr_dir]
%    The CTF archive should expand into orchidee_mcr. Do not forget
%    to also run a client application to test the server.
% 6. Quit the server from your client application, or just send a
%    "/quit" OSC message.
% 7. Remove the script file run_orchidee.sh
% 8. Copy the content of the 'r' dir into the Contents/MacOS/distrib/
%    dir in the Orchidee application bundle.
% 9. Change the version of the application in the Info.plist file
%
% That's it !
%

if length(varargin)

    switch varargin{1}

        case 'clean'

            !rm -f mccExcludedFiles.log
            !rm -f readme.txt
            !rm -f run_orchidee.sh
            !rm -f orchidee
            !rm -f orchidee.ctf
            !rm -f orchidee.prj
            !rm -f orchidee_main.c
            !rm -f orchidee_mcc_component_data.c
            !rm -rf orchidee_mcr
            !rm -rf ../r/

        case 'path'

            handle_paths('load');

        case '-r'

            handle_paths('unload');
            cd ..
            !rm -r r
            !cp -R Sources/ r
            cd r
            handle_paths('load');
            mcc -m -R -nojvm orchidee.m
            handle_paths('unload');
            !rm -r @filter
            !rm -r @knowledge
            !rm -r @orchestra
            !rm -r @searchstructure
            !rm -r @session
            !rm -r @target
            !rm -r analysis
            !rm error_identifyers
            !rm -r features
            !rm handle_paths.m
            !rm -r io
            !rm make.m
            !rm mccExcludedFiles.log
            !rm orchidee.m
            !rm orchidee_main.c
            !rm orchidee_mcc_component_data.c
            !rm orchidee_version.m
            !rm -r osc
            !rm -r path
            !rm readme.txt
            !rm -r utils
            !rm -r multiobjective
            !rm -r genetic
            !rm -r xml
            !rm -r work
            !rm tmp_script.m
            !rm -r mat/old/
            !rm -r errors
            cd ..

    end

else

    make path
    mcc -m -R -nojvm orchidee.m

end

