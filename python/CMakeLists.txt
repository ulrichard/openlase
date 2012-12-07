find_package(PythonLibs)
find_program(CYTHON_EXECUTABLE cython)

if(CYTHON_EXECUTABLE MATCHES "NOTFOUND" OR NOT PYTHONLIBS_FOUND)
  message(STATUS "Will NOT build python bindings (python libs or cython missing)")
else()
  execute_process(COMMAND
    ${PYTHON_EXECUTABLE} -c "from distutils.sysconfig import get_python_lib; print get_python_lib()"
    OUTPUT_VARIABLE PYTHON_SITE_PACKAGES OUTPUT_STRIP_TRAILING_WHITESPACE)

  add_custom_command(OUTPUT pylase.c
    MAIN_DEPENDENCY pylase.pyx
    COMMAND ${CYTHON_EXECUTABLE} -I ${CMAKE_SOURCE_DIR}/include -o pylase.c "${CMAKE_CURRENT_SOURCE_DIR}/pylase.pyx")
    list(APPEND ADDITIONAL_MAKE_CLEAN_FILES pylase.c)

  include_directories(${PYTHON_INCLUDE_PATH} ${CMAKE_SOURCE_DIR}/include)
  add_library(pylase MODULE pylase.c)
  set_target_properties(pylase PROPERTIES
    PREFIX ""
    OUTPUT_NAME "pylase"
    LIBRARY_OUTPUT_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR})
  target_link_libraries(pylase openlase)
  SET_TARGET_PROPERTIES(pylase PROPERTIES
    VERSION ${VERSION_SERIES}.${VERSION_MAJOR}.${VERSION_MINOR}
    SOVERSION ${openlase_SOVERSION}
    DEBUG_POSTFIX "d"
  )

  install(TARGETS pylase
    RUNTIME DESTINATION bin
    LIBRARY DESTINATION ${LIB_INSTALL_DIR}
    ARCHIVE DESTINATION ${LIB_INSTALL_DIR})
  install(FILES ${CMAKE_CURRENT_SOURCE_DIR}/pylase.pyx DESTINATION ${CMAKE_INSTALL_PREFIX}/share/openlase/python)
  install(FILES ${CMAKE_CURRENT_BINARY_DIR}/pylase.c   DESTINATION ${CMAKE_INSTALL_PREFIX}/share/openlase/python)
endif()
