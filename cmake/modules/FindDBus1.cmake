# FindDBus1.cmake - Find DBus1 using pkg-config
include(FindPackageHandleStandardArgs)
find_package(PkgConfig QUIET)

if(PkgConfig_FOUND)
  pkg_check_modules(_DBUS1 QUIET dbus-1)
endif()

find_path(DBus1_INCLUDE_DIR
  NAMES dbus/dbus.h
  HINTS ${_DBUS1_INCLUDE_DIRS}
  PATH_SUFFIXES dbus-1.0
)

# dbus arch-specific include dir (for dbus-arch-deps.h)
find_path(DBus1_ARCH_INCLUDE_DIR
  NAMES dbus/dbus-arch-deps.h
  HINTS ${_DBUS1_INCLUDE_DIRS}
  PATHS
    /usr/lib/*/dbus-1.0/include
    /usr/lib/dbus-1.0/include
)

find_library(DBus1_LIBRARY
  NAMES dbus-1
  HINTS ${_DBUS1_LIBRARY_DIRS}
)

find_package_handle_standard_args(DBus1
  REQUIRED_VARS DBus1_LIBRARY DBus1_INCLUDE_DIR
)

if(DBus1_FOUND AND NOT TARGET DBus1::DBus1)
  add_library(DBus1::DBus1 UNKNOWN IMPORTED)
  set_target_properties(DBus1::DBus1 PROPERTIES
    IMPORTED_LOCATION "${DBus1_LIBRARY}"
    INTERFACE_INCLUDE_DIRECTORIES "${DBus1_INCLUDE_DIR};${DBus1_ARCH_INCLUDE_DIR}"
  )
endif()

# Also set legacy variables
set(DBus1_INCLUDE_DIRS "${DBus1_INCLUDE_DIR}" "${DBus1_ARCH_INCLUDE_DIR}")
set(DBus1_LIBRARIES "${DBus1_LIBRARY}")
