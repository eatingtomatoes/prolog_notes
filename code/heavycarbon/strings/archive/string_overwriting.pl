:- module(heavycarbon_strings_overwriting,
          [
             string_overwriting/4  % string_overwriting(+StrIn,+OvwStr,+OvwPos,?StrOut) 
          ]).
  
:- use_module(library('heavycarbon/strings/conversion.pl')).
:- include(library('heavycarbon/support/meta_helpers_nonmodular.pl')). % Not a module, just (meta) predicates

% == TODO ==
% 
% 1) string_overwriting/4 should maybe be called string_overwrite/4 because 
%    it smells like a function
% 2) string_overwriting/4 can be easily used for left-justfication of text:
%    string_overwriting("          ","Hello",1,X) refines X to " Hello    "
%    To be added:
%    Something to easily perform right-justification of text
%    Something to easily perform center-justification of text
%    Something to easily perform justification of text at a given position 
%    (e.g. to align decimal numbers at their ".")
%    Allow string_overwriting/4 to also extend the "string to be overwritten"
%    ON THE LEFT, not only on the RIGHT, and allow cutting it off ON THE RIGHT
%    not only on the LEFT.
%    All of that is not difficult, just annoying to do. 
%    A good interface would be:
%
%    string_overwriting(StrIn,OvwStr,RefPos,StrOut,Format)
%
%    where Format is:
%
%    ->   RefPos counted from left, negative is further to the left, beyond character 0 
%    <-   RefPos counted from right, negative is further to the right, beyond character length(StrIn)-1
%    <>   RefPos is middle of StrIn
%    <CH> OverwriteStr is center on onee of its characters, e.g. "."
%    [    Cut on the left instead of allowing the string to grow there
%    ]    Cut on the right instead of allowing the string to grow there
%
%    Then one could have format strings like: "[->" or "[<-]" or "[<.>]" etc.

% ===
% (Partially) ovwerwrite an original string "StrIn" with "OvwStr" (the "overwrite string"),
% giving a "StrOut".
%
% The overwriting starts at (0-indexed) "OverwritePos" (possibly negative, which is 
% interpreted as "further to the left", NOT "index from the end of the "StrIn" leftwards).
% Overwriting may involve overwriting characters in the middle of "StrIn", appending to
% "StrIn", with or without partial overwriting, or appending to "StrIn" and filling any gap
% between the end of "StrIn" and the start of "OverwriteStr" at "OverwritePos" with spaces.
%
% Example of overwriting "Lorem ipsum dolor sit amet, consectetur adipiscing elit"
% with "[perspiciatis]" at various indexes:
%
%  -6   "iciatis]sum dolor sit amet, consectetur adipiscing elit"
%  -5   "piciatis]um dolor sit amet, consectetur adipiscing elit"
%  -4   "spiciatis]m dolor sit amet, consectetur adipiscing elit"
%  -3   "rspiciatis] dolor sit amet, consectetur adipiscing elit"
%  40   "Lorem ipsum dolor sit amet, consectetur [perspiciatis]t"
%  41   "Lorem ipsum dolor sit amet, consectetur a[perspiciatis]"
%  42   "Lorem ipsum dolor sit amet, consectetur ad[perspiciatis]"
%  43   "Lorem ipsum dolor sit amet, consectetur adi[perspiciatis]"
%  44   "Lorem ipsum dolor sit amet, consectetur adip[perspiciatis]"
%  45   "Lorem ipsum dolor sit amet, consectetur adipi[perspiciatis]"
%  55   "Lorem ipsum dolor sit amet, consectetur adipiscing elit[perspiciatis]"
%  56   "Lorem ipsum dolor sit amet, consectetur adipiscing elit [perspiciatis]"
%  57   "Lorem ipsum dolor sit amet, consectetur adipiscing elit  [perspiciatis]"
%  58   "Lorem ipsum dolor sit amet, consectetur adipiscing elit   [perspiciatis]"
%  59   "Lorem ipsum dolor sit amet, consectetur adipiscing elit    [perspiciatis]"
% ===

string_overwriting(StrIn,OvwStr,OvwPos,StrOut) :-
   must_be(integer,OvwPos),               % will throw of non-integer (should this be inside an assertion?)
   convert_to_string(StrIn,StrInSure),    % will throw if conversion-to-string impossible (i.e. this is pretty lenient)
   convert_to_string(OvwStr,OvwStrSure),  % will throw if conversion-to.string impossible (i.e. this is pretty lenient)
   string_length(StrInSure,StrInLen),
   string_length(OvwStrSure,OvwStrLen),
   (((OvwPos + OvwStrLen =< 0) ; (OvwStrLen == 0))
      ->  % nothing to do; OvwStr is too far left or empty
      leveling_string(StrInSure,StrOut)
      ;   % proceed normally
      (ovw_helper_top(StrInSure,StrInLen,OvwStrSure,OvwStrLen,OvwPos,StrOutSure),
       leveling_string(StrOutSure,StrOut))).

% ---
% Helpers
% --- 

ovw_helper_top(StrIn,StrInLen,OvwStr,OvwStrLen,OvwPos,StrOut) :-
   if_then_else(
      % if
      (OvwPos < 0),
      % then cut off any characters of PatchStr that are not visible 
      ((Before is -OvwPos,
        OvwStrLenFixed is OvwStrLen-Before,
        sub_string(OvwStr,Before,OvwStrLenFixed,0,OvwStrFixed),
        ovw_helper_mid(StrIn,StrInLen,OvwStrFixed,OvwStrLenFixed,0,StrOut))),
      % else proceed normally
      (ovw_helper_mid(StrIn,StrInLen,OvwStr,OvwStrLen,OvwPos,StrOut))).
    
ovw_helper_mid(StrIn,StrInLen,OvwStr,OvwStrLen,OvwPos,StrOut) :-
   OvwPosEnd is OvwPos+OvwStrLen,
   switch(
      % a suffix of StrInLen (and maybe a prefix) must be kept
      (OvwPosEnd < StrInLen), 
      (ovw_string_with_suffix(StrIn,OvwStr,OvwPos,OvwPosEnd,StrOut)),
      % only (maybe) a prefix of StrInLen must be kept
      (OvwPos < StrInLen),
      (ovw_string_without_suffix(StrIn,OvwStr,OvwPos,StrOut)),
      % the OvwStr shall be appended to StrIn with possibly spaces in between
      (StrInLen =< OvwPos),
      (ovw_string_append(StrIn,StrInLen,OvwStr,OvwPos,StrOut)),
      % else never happens
      (cannot_happen_error("impossible case"))).

ovw_string_with_suffix(StrIn,OvwStr,OvwPos,OvwPosEnd,StrOut) :-
   sub_string(StrIn,0,OvwPos,_,Prefix),
   sub_string(StrIn,OvwPosEnd,_,0,Suffix),
   string_concat(Prefix,OvwStr,SX),
   string_concat(SX,Suffix,StrOut).
 
ovw_string_without_suffix(StrIn,OvwStr,OvwPos,StrOut) :-
   sub_string(StrIn,0,OvwPos,_,Prefix),
   string_concat(Prefix,OvwStr,StrOut).

ovw_string_append(StrIn,StrInLen,OvwStr,OvwPos,StrOut) :-
   SpaceCount is OvwPos-StrInLen,
   string_of_spaces(SpaceCount,Spaces),
   string_concat(StrIn,Spaces,SX),
   string_concat(SX,OvwStr,StrOut).


