# https://cmake.org/cmake/help/latest/cpack_gen/archive.html#cpack_gen:CPack%20Archive%20Generator

include(CPackComponent)

# Enable component packaging for CPackArchive
# https://cmake.org/cmake/help/latest/cpack_gen/archive.html#variable:CPACK_ARCHIVE_COMPONENT_INSTALL
set(CPACK_ARCHIVE_COMPONENT_INSTALL ON)

# ALL_COMPONENTS_IN_ONE : create a single package with all requested components
# https://cmake.org/cmake/help/latest/module/CPackComponent.html#variable:CPACK_COMPONENTS_GROUPING
set(CPACK_COMPONENTS_GROUPING ALL_COMPONENTS_IN_ONE)

# Add "full" installation type.
cpack_add_install_type(full 
    DISPLAY_NAME "Full installation"
)

# Create 2 installation components vst3plugin and vst3presets.
# vst3plugin
cpack_add_component(
    vst3plugin
    DISPLAY_NAME "VST3 Plugin"
    INSTALL_TYPES full
)

# vst3presets
cpack_add_component(
    vst3presets
    DISPLAY_NAME "VST3 Presets"
    INSTALL_TYPES full
)

# Component specific installation directory for the 'vst3plugin' and the 'vst3presets' components, see VST3 SDK doc
# https://steinbergmedia.github.io/vst3_dev_portal/pages/Technical+Documentation/Locations+Format/Plugin+Locations.html
# https://steinbergmedia.github.io/vst3_dev_portal/pages/Technical+Documentation/Locations+Format/Preset+Locations.html

# Inno Setup settings: https://cmake.org/cmake/help/latest/cpack_gen/innosetup.html
# NSIS settings: https://nsis.sourceforge.io/Docs/Chapter4.html

# Installation path for the 'vst3plugin'
set(CPACK_NSIS_vst3plugin_INSTALL_DIRECTORY "$COMMONFILES64")           # C:\Program Files\Common Files\
set(CPACK_INNOSETUP_vst3plugin_INSTALL_DIRECTORY "{commoncf64}")        # C:\Program Files\Common Files\
set(CPACK_INNOSETUP_ALLOW_CUSTOM_DIRECTORY OFF)                         # Do not let the user choose another install directory

# Installation path for the 'vstpresets'
set(CPACK_INNOSETUP_vst3presets_INSTALL_DIRECTORY "{commonappdata}")    # C:\Program Data\
set(CPACK_NSIS_vst3presets_INSTALL_DIRECTORY "$COMMONPROGRAMDATA")      # C:\Program Data\

# Instead of "C:\Program Files\Company MyPlugin", better create "C:\Program Files\Company\MyPlugin"
set(CPACK_INNOSETUP_INSTALL_ROOT "{autopf}/${CPACK_PACKAGE_VENDOR}")
set(CPACK_NSIS_INSTALL_ROOT "$PROGRAMFILES64/${CPACK_PACKAGE_VENDOR}")
string(REGEX REPLACE "/" "\\\\" CPACK_NSIS_INSTALL_ROOT "${CPACK_NSIS_INSTALL_ROOT}") # Workaround, see https://gitlab.kitware.com/cmake/cmake/-/issues/20072