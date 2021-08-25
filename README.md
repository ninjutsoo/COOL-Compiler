# Compiler-Projects
## Phase 1
#### These are 3 set of assignments meant to be an introduction to COOL programming language.
## Phase 2
this was the lexer phase for cool compiler.
lexer works az an scanner and tokenizer, that will recogonize each part.
we will start with the my defenitions part, I have an boolean named wrong_str
that it was for the first time I finished the project for changing the flag
when I see errors in the strings but I handled it with a conditon named "ESC".
i begin this condition when I see errors like null or too long screen so we 
will not come out until we see an \n (new-line) or ".
i have defined "rem_str" for my remaining room to store strings in string_buf.
at first as we know it is equal to MAX_STR_CONST (1025).
curr_lineno is a counter that increases with each newline, so we can show the 
line for tokens and errors.
i defined a function (write_str) that writes the string in the string_buf
using strncpy.each time that we write, we will but a null character "\0" end 
of that so the string table and parser know where is the end of it.
we also have a part to realize "too long string" error but it is built 
other where, this was for first time programing this and is not used.
next part we define regular expressions for keywords and identifiers, so 
we work with them in the next section properly.
we have 3 conditions, the purpose behind them is clean code and easily know 
where you are(it will work like a flag for each positon), in the comments
or strigns or code(body). the default for code(body) is INITIAL and the ESC
as I said in the comment is for when we see a null or too long error and we 
will escape from that just with /n or *. it is used not to lexing other part
of that.
we started with comments. first part of second section is for comments, and it's errors like EOF.
we have two kind of comments, first, ((**)) second, (--). secod part is for strings and it's the most important one cause of multiple  errors that it has. EOF, NULL, TOO LONG AND UNTERMINATED are their (brief :)) errors.
we have some exceptions for (backslash) such as \n or \f or ..., but for \(other characters) we ignore \.
after them we go for other patterns, most important one are objectid and typeid that the difference is at first index of them. every character that we didn't defined will show as an error.
