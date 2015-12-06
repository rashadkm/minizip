set(AES_SRCS
  aescrypt.c
  aeskey.c
  aestab.c
  entropy.c
  fileenc.c
  hmac.c
  prng.c
  pwd2key.c
  sha1.c)

include_directories(${CMAKE_CURRENT_SOURCE_DIR})
add_library(aes STATIC ${AES_SRCS})