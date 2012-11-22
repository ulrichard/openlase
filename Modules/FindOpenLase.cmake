# - Try to find OpenLase
# Once done, this will define
#
#  OpenLase_FOUND - system has OpenLase
#  OpenLase_INCLUDE_DIRS - the OpenLase include directories
#  OpenLase_LIBRARIES - link these to use OpenLase

find_path(OpenLase_INCLUDE_DIR
  NAMES libol.h
  PATHS /usr/include/openlase /usr/local/include/openlase
)

find_library(OpenLase_LIBRARY
  NAMES openlase
  PATHS /usr/lib /usr/local/lib
)

SET(OpenLase_INCLUDE_DIRS ${OpenLase_INCLUDE_DIR})
SET(OpenLase_LIBRARIES    ${OpenLase_LIBRARY})

INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(OpenLase  DEFAULT_MSG
	OpenLase_INCLUDE_DIR OpenLase_LIBRARY
)

