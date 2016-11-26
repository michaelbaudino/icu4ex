Nonterminals message elems elem string argument select_output select_options select_option.
Terminals '{' '}' ',' word space number percent date time select.
Rootsymbol message.

message -> '$empty' : [].
message -> elems : '$1'.

elems -> elem : ['$1'].
elems -> elem elems : ['$1'|'$2'].

elem -> string : {string, '$1'}.
elem -> argument: '$1'.

string -> word : extract_value('$1').
string -> space : extract_value('$1').
string -> ',' : extract_value('$1').
string -> word string : [extract_value('$1')|'$2'].

argument -> '{' word '}' : {simple, extract_value('$2')}.
argument -> '{' word ',' number '}' : {number, extract_value('$2')}.
argument -> '{' word ',' number ',' percent '}' : {number, extract_value('$2'), percent}.
argument -> '{' word ',' date '}'  : {date, extract_value('$2')}.
argument -> '{' word ',' date ',' word '}'  : {date, extract_value('$2'), extract_value('$6')}.
argument -> '{' word ',' time '}'  : {time, extract_value('$2')}.
argument -> '{' word ',' time ',' word '}'  : {time, extract_value('$2'), extract_value('$6')}.
argument -> '{' word ',' select ',' select_output '}' : {select, extract_value('$2'), '$6'}.

select_output -> select_option : ['$1'].
select_output -> select_option space select_output : ['$1'|'$3'].

select_option -> word space '{' elems '}' : {extract_value('$1'), '$4'}.

Erlang code.

extract_value({_Token, _Line, Value}) -> Value.
