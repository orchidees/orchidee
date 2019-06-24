function [param_s] = FextractParamFromName(filename, nomenclature)
%function [param_s] = FextractParamFromName(filename, nomenclature)
%
% Extrait d'un nom de fichier son le nom de l'instrument, la note jouée, l'octave de la note, la nuance. 
% Il serait interessant de pouvoir spécifier une nomenclature en entrée ...
%
% ===INPUTS
% Un nom de fichier suivant une certaine ? nomenclature
%
%
% ===OUTPUTS
%
%
%

    
%% sol2.0
filename = strrep(filename, ' ', '');    
switch(nomenclature)
    
 case 'sol1.0'
  pat = '(?<instrument>^\w+?)_.+_(?<nuance>\w+)_(?<note>\w+)_12.wav';
  param_s = regexp(filename, pat, 'names');
 
 case 'sol2.0'
  
  pat = '(?<note>[A-G]#?[0-9]\+?)';
  param_s = regexp(filename, pat, 'names');
  
  if isempty(param_s)
      param_s(1).note = 'none';
      note = 'none';
      octave = 0;
  end
  
  % si il y a plusieurs notes dans le nom de fichier
  if length(param_s) >= 2
      i_start = min(regexp(filename, pat, 'start'));
      i_end = max(regexp(filename, pat, 'end'));
      note = filename(i_start:i_end);
      param_s = [];
      param_s(1).note = note;
      octave = NaN;
  end

  % si il existe une note, on l'utilise comme reference pour trouver le reste sinon ...
  if ~strcmp(param_s.note, 'none');
      note_asc = strrep(param_s.note, '+', '\+');
      pat = ['(?<instrument>^[a-z_A-Z]+)\+?(?<sourdine>[a-z_A-Z]*)-(?<modeDeJeu>.*)-(?<note>' note_asc ')-(?<dynamique>[m f p]+)-?'];
      param_s = regexp(filename, pat, 'names');
      octave = regexp(param_s.note, '\d', 'match');
      param_s.octave = str2num(octave{1});
  else
      pat = ['(?<instrument>^[a-z_A-Z]+)\+?(?<sourdine>[a-z_A-Z]*)-(?<modeDeJeu>.*)-(?<dynamique>[m f p]+)-?'];
      param_s = regexp(filename, pat, 'names');
      param_s.note = note;
      param_s.octave = octave;
  end
  % Numero de corde
  pat = '[1-6]c';
  pos_v = regexp(filename, pat);
  param_s.cordes_v = str2num(filename(pos_v)');
  if isempty(param_s.sourdine)
      param_s.sourdine = 'N';
  end
  param_s = orderfields(param_s, {'instrument', 'sourdine', 'modeDeJeu', ...
                        'note', 'octave', 'dynamique', 'cordes_v'});
 case 'vienna'
%  [NUMERIC,vienna2sdb_c,RAW]=XLSREAD('~/Orchestration/sdb/SDB_Vienna-_SOL-short.xlw');
  pat = ['(?<instrument>^[a-z_A-Z0-9\-]+?)_(?<modeDeJeu>.*?)_(?<dynamique>[a-z]+)[0-9]?_(?<note>[A-G]#?[0-9]).wav'];
  param_s = regexp(filename, pat, 'names');
  
 case 'violonNMD'
  gamme = cellstr(strvcat('do', 'dod', 're', 'red', 'mi', 'fa', 'fad', 'sol', 'sold', 'la', 'lad', 'si'));
  diatoniqueMajeur = [0, 2, 4, 5, 7, 9, 11];
  reMaj = gamme(mod(diatoniqueMajeur+2, 12)+1);
  
  pat = '(?<player>^\w)-(?<nuance>\w+)-(?<mode>\w+)-(?<noteNb>\d+).aiff';
  param_s = regexp(filename, pat, 'names');
  param_s.noteNb = str2num(param_s.noteNb);
  if param_s.noteNb <= 7
      param_s.note = reMaj{param_s.noteNb};
  elseif param_s.noteNb > 8
      param_s.note = reMaj{16 - param_s.noteNb};
  else
      param_s.note = 're';
  end

  case 'iowa'
    pat = '^(\w+)\.(\w*\.)?(\w+)\.(sul\w)*\.?(\w+)\.wav';
    a = regexp(filename, pat, 'tokens');
    param_s.instrument = a{1}{1};
    param_s.modeDeJeu = strrep(a{1}{2}, '.', '');
    param_s.dynamique = a{1}{3};
    param_s.cordes_v = strrep(a{1}{4}, 'sul', '');
    param_s.note = a{1}{5};
    
  case 'virto'
    pat = '(\w+)-?(\w+)?-(\w+\#?\w)-(\w+).AIF';
    a = regexp(filename, pat, 'tokens');
    param_s.instrument = a{1}{1};
    param_s.dynamique = a{1}{4};
    param_s.cordes_v = a{1}{2};
    param_s.note = a{1}{3};
end
