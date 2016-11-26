Definitions.

WORD       = [^{},\s\t\r\n]+
WHITESPACE = [\s\r\r\n]

Rules.

\{\s*         : {token, {'{', TokenLine}}.
\s*\}         : {token, {'}', TokenLine}}.
\,\s*         : {token, {',', TokenLine, TokenChars}}.
number        : {token, {number, TokenLine}}.
percent       : {token, {percent, TokenLine}}.
date          : {token, {date, TokenLine}}.
time          : {token, {time, TokenLine}}.
select        : {token, {select, TokenLine}}.
{WORD}        : {token, {word, TokenLine, TokenChars}}.
{WHITESPACE}+ : {token, {space, TokenLine, TokenChars}}.

Erlang code.
