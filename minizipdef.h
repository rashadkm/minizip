#ifndef MINIZIPEXTERN
#  ifdef MINIZIP_DLL
#    if defined(WIN32) && (!defined(__BORLANDC__) || (__BORLANDC__ >= 0x500))
#      ifndef MINIZIP_EXTERNAL
#        define MINIZIPEXTERN extern __declspec(dllexport)
#      else
#        define MINIZIPEXTERN extern __declspec(dllimport)
#      endif
#    endif
#  endif  /* MINIZIP_DLL */

#   ifndef MINIZIPEXTERN
#      define MINIZIPEXTERN extern
#   endif
#endif
