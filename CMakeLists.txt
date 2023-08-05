cmake_minimum_required(VERSION 3.19)

project("VST3 CPack"
    VERSION 2023.08
    LANGUAGES NONE
)

set(VST3_CPACK_SOURCE_DIR ${PROJECT_SOURCE_DIR} CACHE STRING "Path to VST3 CPack")

# Include files here in order to bring macros into scope
list(APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake/modules)
include(VST3ConfigureCPack)

# Copy CPack options file to the binary directory for later use
configure_file(
    "${PROJECT_SOURCE_DIR}/cmake/modules/VST3CPackOptions.cmake" 
    "${CMAKE_BINARY_DIR}/CMakeScripts/VST3CPackOptions.cmake" @ONLY
)
