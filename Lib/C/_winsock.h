// winsock.h wrapper
// Includes winsock.h while avoiding conflicts with Oberon types.

#define BOOLEAN _BOOLEAN
#define BYTE _BYTE
#define CHAR _CHAR
#include <winsock.h>
#undef BOOLEAN
#undef BYTE
#undef CHAR
