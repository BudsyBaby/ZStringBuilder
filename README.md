# ZStringBuilder
SwiftForth SWOOP class for building strings large or small, inspired by .NET StringBuilder class

***********************************************
**  by Robert Dickow, aka Budsy              **
***********************************************

## License

This project is licensed under the MIT License. See the LICENSE file for details.

## Requirements

SwiftForth 32/64 or compatible Forth system

Tested with:

- SwiftForth 4.1.8

## Features

Manages an expandable string in a system RAM buffer
Dynamically and transparently expands storage as strings are appended
Easy words to initialize, free and clear the buffer
Unlimited string size (except by available RAM of course.)

## Files

- `zstring-builder-class.f` - class code.
- `test.f` - simple test.
- `README.md` - this readme file.


## general usage:

- ... declare a class instance.
- ... call INIT before doing any other operations.
- ...   will initialize the string buffer with 0 length string.
- ... APPEND or APPENDLINE zstrings to end of current string.
- ... GET the current zstring as desired for printing, etc.
- ...   or TYPE to print the string
- ... CLEAR for resetting to empty string and for rebuilding if desired.
-     (does not FREE the memory)
- ... FREE when done. Must call INIT again to reuse instance.

## available class methods (words):

    INIT ( -- ) \ initialize by creating a 0 len string in new allocated buffer.
                 \ call init after FREE if reuse is desired.
    CLEAR ( -- ) \  clear the string to empty string, but still leaves allocated memory
    FREE  ( -- ) \ cleanup using this. Class may still be INITted again for reuse.
    APPEND ( zptr -- ) \ add a string to the end of current string.
    APPENDLINE ( zptr -- ) \ adds a string with new line appended.
    GET    ( -- zptr ) \ returns the address of the current zstring buffer
       Throws exception AllocError if problem allocating memory occurs.
    LENGTH ( -- n ) \ length of instance string in characters
    TYPE   ( -- )  \ prints the current string to the console.

## Running

```bash
include test demo

## Example declaration and usage:

include ZSTRING-BUILDER-CLASS

zstring-builder builds str \ declare static instance 'str' word

str init \ first call the init method
z" Hello World!" str appendline \ append string to empty buffer
str length cr .  \ print the length of the string.
str type \ prints the string to the console.
str free \ frees allocated memory. Do when done to free allocated memory resources.

\ See SwiftForth documentation for how to use dynamic object declaration and use.
