function [psyphycell, table01all, session_table, hf] = analyze_tra(parset, makefig, makestats)
%
%
%

if (nargin<3) makestats = 0; end
if (nargin<2) makefig = 0; end
[psyphycell, table01all, session_table, hf] = analyze_ftr(parset, makefig, makestats);
