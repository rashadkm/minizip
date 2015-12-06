function(external_project name)
  set(PKG_NAME ${name})
  string(TOLOWER ${PKG_NAME} PKG_NAME_)
  set (extra_args ${ARGN})
  list(LENGTH extra_args num_extra_args)
  if (${num_extra_args} GREATER 0)
    list(GET extra_args 0 PKG_REPO)
    message ("Got a repo argument: ${PKG_REPO}")
  else()
    set(PKG_REPO ${PKG_NAME_})
  endif ()
  
  find_package(${PKG_NAME})
  
  if(NOT ${PKG_NAME}_FOUND)    
    ExternalProject_Add(${PKG_NAME}
      GIT_REPOSITORY ${EP_URL}/${PKG_REPO}
      DOWNLOAD_COMMAND ""
      CONFIGURE_COMMAND ""
      UPDATE_COMMAND ""        
      INSTALL_COMMAND
      )
    
    set(${PKG_NAME}_INSTALL_DIR ${CMAKE_BINARY_DIR}/third-party/Install/${PKG_NAME})
    
    if(NOT EXISTS "${CMAKE_BINARY_DIR}/third-party/Stamp/${PKG_NAME}/${PKG_NAME}-download")
      execute_process(COMMAND git clone ${EP_URL}/${PKG_REPO} ${PKG_NAME}
        WORKING_DIRECTORY  ${CMAKE_BINARY_DIR}/third-party/Source)
      
      execute_process(COMMAND ${CMAKE_COMMAND}  -E touch "${PKG_NAME}-download"
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/third-party/Stamp/${PKG_NAME} )  
    endif()
    
    execute_process(COMMAND ${CMAKE_COMMAND} ${CMAKE_BINARY_DIR}/third-party/Source/${PKG_NAME}
      "-DCMAKE_INSTALL_PREFIX=${${PKG_NAME}_INSTALL_DIR}"
      WORKING_DIRECTORY ${CMAKE_BINARY_DIR}/third-party/Build/${PKG_NAME} )
    
    #TODO: update lib_z repo
    include(${ep_base}/Build/${PKG_NAME}/${PKG_NAME}Targets.cmake)
    
    get_target_property(${PKG_NAME}_LIBRARIES_ ${PKG_NAME_} IMPORTED_LOCATION_NOCONFIG)
    
    set(${PKG_NAME}_INCLUDE_DIRS ${${PKG_NAME}_INSTALL_DIR}/include PARENT_SCOPE)
    set(${PKG_NAME}_LIBRARIES ${${PKG_NAME}_LIBRARIES_} PARENT_SCOPE)
    
  else()
    set(${PKG_NAME}_INCLUDE_DIRS ${${PKG_NAME}_INCLUDE_DIR} PARENT_SCOPE)
    set(${PKG_NAME}_LIBRARIES ${${PKG_NAME}_LIBRARY} PARENT_SCOPE)
  endif()
  
endfunction()

