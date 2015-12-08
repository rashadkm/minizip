cmake_minimum_required(VERSION 2.6)

project(minizip C)

set(INSTALL_BIN_DIR "${CMAKE_INSTALL_PREFIX}/bin" CACHE PATH "Installation directory for executables")
set(INSTALL_LIB_DIR "${CMAKE_INSTALL_PREFIX}/lib" CACHE PATH "Installation directory for libraries")
set(INSTALL_INC_DIR "${CMAKE_INSTALL_PREFIX}/include/minizip" CACHE PATH "Installation directory for headers")
set(INSTALL_MAN_DIR "${CMAKE_INSTALL_PREFIX}/share/man" CACHE PATH "Installation directory for manual pages")
set(INSTALL_PKGCONFIG_DIR "${CMAKE_INSTALL_PREFIX}/share/pkgconfig" CACHE PATH "Installation directory for pkgconfig (.pc) files")

set(VERSION_MAJOR "1")
set(VERSION_MINOR "2")
set(VERSION_PATCH "8")
set(VERSION_STRING "${VERSION_MAJOR}.${VERSION_MINOR}.${VERSION_PATCH}")

option(BUILD_SHARED_LIBS  "Build shared libs." ON)
option(BUILD_TESTS "Build demos." ON)
option(BUILD_DEMOS  "Build demos." ON)

include (CheckIncludeFile)

check_include_file("unistd.h" HAVE_UNISTD_H)
check_include_file("sys/types.h" HAVE_SYS_TYPES_H)
check_include_file("sys/stat.h" HAVE_SYS_STAT_H)
check_include_file("stdint.h" HAVE_STDINT_H)
check_include_file("dlfcn.h" HAVE_DLFCN_H)
check_include_file("stddef.h"    HAVE_STDDEF_H)
check_include_file("ctype.h" HAVE_CTYPE_H)
check_include_file("stdlib.h" HAVE_STDLIB_H)
check_include_file("inttypes.h" HAVE_INTTYPES_H)
check_include_file("strings.h" HAVE_STRINGS_H)
check_include_file("string.h" HAVE_STRING_H)


# set path to additional CMake modules
set(CMAKE_MODULE_PATH ${CMAKE_SOURCE_DIR}/cmake ${CMAKE_MODULE_PATH})

include(ExternalProject)
set(ep_base "/home/rashad/sources/cmake-build/third-party")
set_property(DIRECTORY PROPERTY "EP_BASE" ${ep_base})

set(EP_URL "https://github.com/rashadkm")
find_package(Git)

include(External)

external_project(ZLIB lib_z)

#The above macro calls find_package(ZLIB) and if not found build it download and build it for you!
#find_package(ZLIB)


if (HAVE_CTYPE_H AND HAVE_STDLIB_H)
    set(STDC_HEADERS 1)
endif ()

set(MINIZIP_SRCS
  ioapi.c
  unzip.c
  zip.c)

if(WIN32)
  list(APPEND MINIZIP_SRCS iowin32.c)
endif()

set(MINIZIP_INCS
  crypt.h 
  ioapi.h 
  unzip.h 
  zip.h)

if(WIN32)
  list(APPEND MINIZIP_INCS iowin32.h)
endif()

add_library(minizip ${MINIZIP_SRCS})
add_dependencies(minizip ZLIB)

include_directories(${ZLIB_INCLUDE_DIRS})

target_link_libraries(minizip ${ZLIB_LIBRARIES})
set_target_properties(minizip PROPERTIES SOVERSION ${VERSION_STRING})

if(BUILD_DEMOS)
  add_definitions(-DHAVE_AES)
  add_subdirectory(aes)
  add_executable(miniunz miniunz.c)
  target_link_libraries(miniunz minizip ${ZLIB_LIBRARIES} aes)

  install(TARGETS miniunz 
    RUNTIME DESTINATION "${INSTALL_BIN_DIR}"
    ARCHIVE DESTINATION "${INSTALL_LIB_DIR}"
    LIBRARY DESTINATION "${INSTALL_LIB_DIR}" )

  add_executable(minizipz minizip.c)
  target_link_libraries(minizipz minizip ${ZLIB_LIBRARIES} aes)

  install(TARGETS minizipz
    RUNTIME DESTINATION "${INSTALL_BIN_DIR}"
    ARCHIVE DESTINATION "${INSTALL_LIB_DIR}"
    LIBRARY DESTINATION "${INSTALL_LIB_DIR}" )

endif()

configure_file( ${CMAKE_CURRENT_SOURCE_DIR}/minizip.pc.cmakein
  ${CMAKE_CURRENT_BINARY_DIR}/minizip.pc @ONLY)

install(FILES ${CMAKE_CURRENT_BINARY_DIR}/minizip.pc
  DESTINATION
  "${INSTALL_PKGCONFIG_DIR}")

install(TARGETS minizip 
  RUNTIME DESTINATION "${INSTALL_BIN_DIR}"
  ARCHIVE DESTINATION "${INSTALL_LIB_DIR}"
  LIBRARY DESTINATION "${INSTALL_LIB_DIR}" )

install(FILES ${MINIZIP_INCS} DESTINATION "${INSTALL_INC_DIR}")

export(TARGETS minizip
  FILE "${CMAKE_BINARY_DIR}/minizipTargets.cmake")


if(BUILD_TESTS)
  enable_testing()
endif()