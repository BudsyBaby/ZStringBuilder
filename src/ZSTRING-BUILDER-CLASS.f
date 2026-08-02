\ =======================================================
\ ZSTRING-BUILDER (Version 2.1)
\ Bob Dickow (this optimized growth version)
\ for large strings and 32/64-bit SwiftForth
\ ZSTRING-BUILDER SWOOP class
\ August 2026  Bob Dickow, Moscow, ID dickow@turbonet.com
\ =======================================================

THROW#

s" Memory allocation error in ZSTRING-BUILDER instance. " >THROW ENUM AllocError
s" Memory buffer not initialized in ZSTRING-BUILDER instance. " >THROW ENUM InitializationError

To THROW#

CLASS ZSTRING-BUILDER

PROTECTED

  variable buff        \ pointer to buffer for string char storage.
  variable len         \ current string length (bytes, no terminator)
  variable cap         \ max capacity of current buffer.
  64 constant defaultcap         \ minimum capacity in bytes
  create CRLF $0D c, $0A c, 0 c, \ line break

  \ --------------------------
  \ helpers
  \ --------------------------

  : _BUFF@   ( -- addr ) buff @ ;
  : _LEN@    ( -- u )    len @ ;
  
  : _FREEBUFF ( -- )
    _BUFF@ ?dup if free drop then
    buff off
    len off
  ;
  
  : MY-EMIT ( c -- )
     DUP $0D = IF DROP CR EXIT THEN
     DUP $0A = IF DROP EXIT THEN
     EMIT
  ;
  
   
  \ ------------------------------------------------------------
  \ Ensure capacity for at least N bytes (including terminator)
  \ ------------------------------------------------------------
  : _ENSURE ( needed -- )
    dup cap @ <= if drop exit then
    >r                            \ save needed
    cap @ dup 0= if drop 64 then  \ safety
    begin
      dup r@ <
    while
      2*
    repeat
    r> drop                     \ done with needed
    dup cap !        ( newcap ) \ save new capacity value
    _BUFF@ ?dup if
      swap ( over ) RESIZE 0<> if drop AllocError throw then
    else
      \ non-forgiving if currently nothing is allocated.
      InitializationError throw \ throw instead.
    then
    buff ! \ store new address of buffer
  ;

 PUBLIC

  \ --------------------------
  \ INIT
  \ --------------------------

  : INIT ( -- )
    _FREEBUFF
    defaultcap dup cap ! ALLOCATE 0<> if drop AllocError throw then
    buff !
    0 _BUFF@ c!  \ empty string
    len off   
  ;
  

  \ --------------------------
  \ CLEAR (keep memory)
  \ --------------------------

  : CLEAR ( -- )
    len OFF
    0 _BUFF@  c!
  ;

  \ --------------------------
  \ FREE
  \ --------------------------

  : FREE ( -- )
    _FREEBUFF
  ;

  \ ----------------------------------------
  \ Compute zstring length (safe, no limits)
  \ ----------------------------------------
  
  : ZLEN ( zstr -- u )
    dup begin 
      dup c@ 
      while 
        1+ 
      repeat
    swap -
  ;

  \ --------------------------
  \ APPEND zstring, concatenate to string
  \ --------------------------

  : APPEND ( zstr -- )
      dup ZLEN >r               \ R: newlen
      dup _BUFF@ =              \ flag
      _LEN@ r@ + 1+ _ENSURE
      if                        \ self append?
        drop                    \ discard stale source address
        _BUFF@                  \ use relocated buffer
      then
      _BUFF@ _LEN@ +            \ src dest
      r@ move                   \ copy newlen bytes
      _LEN@ r@ + dup len !
      _BUFF@ + 0 swap c!
      r> drop
  ;


  \ --------------------------
  \ APPENDLINE (CRLF) adds a line break at end.
  \ --------------------------
  
  : APPENDLINE ( zstr -- )
    APPEND
    CRLF APPEND
  ;

  \ --------------------------
  \ GET get the address of the string buffer
  \ --------------------------

  : GET ( -- zstr )
    _BUFF@
  ;

  \ -----------------------
  \ return length of current string
  \ -----------------------
  
  : LENGTH   ( -- n )
    _LEN@ 
  ;

  \ ------------------
  \ print the string
  \ ------------------

  : TYPE  ( -- ) 
    _LEN@ 0> if 
      _LEN@  0 do 
      _BUFF@ i + c@  MY-EMIT ( see MY-EMIT in demo.f )
      loop
    then
  ;

END-CLASS
