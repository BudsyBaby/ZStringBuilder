\ **********************
\ ZSTRING-BUILDER class demo
\ **********************

: MY-EMIT ( c -- )
     DUP 13 = IF DROP CR EXIT THEN
     DUP 10 = IF DROP EXIT THEN
     EMIT
;

include ZSTRING-BUILDER-CLASS

\ static instance demo:
 ZSTRING-BUILDER builds str

\ N.B. The builder will insert a newline sequence $0D, $0A
\ when using appendline. If you want to avoid seeing funny
\ non-printable characters in the IDE Gui, use something like
\ this EMIT substitute and use this in ZSTRING-BUILDER instead
\ of the word EMIT in the word TYPE.
\
{
  : MY-EMIT ( c -- )
     DUP 13 = IF DROP CR EXIT THEN
     DUP 10 = IF DROP EXIT THEN
     EMIT
  ;
}



\ build a long string by appending
\ and append
 : demo   ( -- )
  str init  
  z" Silly Pickles!!!" 
  str append
  5 0 do
    str get str appendline 
  loop
  cr 
  str type
  str free 
;  

demo