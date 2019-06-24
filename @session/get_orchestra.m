function [instlist,resolution] = get_orchestra(session_instance)

% GET_ORCHESTRA - Orchestra data (instrument list and microtonic
% resolution) accessor.
%
% Usage: [instlist,resolution] = get_orchestra(session_instance)
%

instlist = get_instlist(session_instance.orchestra);
resolution = get_resolution(session_instance.orchestra);