#[=======================================================================[.rst:
VST3ConfigureCPack
------------------

Configure CPack to be used in a VST3 project.

.. command:: vst3_cpack_configure

  .. code-block:: cmake

    vst3_cpack_configure(PLUGIN_PACKAGE_PATH PLUGIN_PRESETS_PATH)

  ::

    PLUGIN_PACKAGE_PATH - The directory path to the VST3 package.
    PLUGIN_PRESETS_PATH - The directory path to the VST3 presets.

  Example:

  .. code-block:: cmake

    vst3_cpack_configure(
        PLUGIN_PACKAGE_PATH "/path/to/build/Release/MyPlugin.vst3"
        PLUGIN_PRESETS_PATH "/path/to/MyPlugin/presets"
    )

#]=======================================================================]

macro(vst3_cpack_configure)
    cmake_parse_arguments(
        VST3_CPACK_CONFIGURE                # Prefix of output variables e.g. VST3_CPACK_CONFIGURE_PLUGIN_PACKAGE_PATH
        ""                                  # List of names for boolean arguments
        "PLUGIN_PACKAGE_PATH;PLUGIN_PRESETS_PATH"   # List of names for mono-valued arguments
        ""                                  # List of names for multi-valued arguments resp. lists
        ${ARGN}                             # Arguments of the function to parse
    )

    if(VST3_CPACK_CONFIGURE_UNPARSED_ARGUMENTS)
		message(WARNING "[VCP] Unparsed arguments: ${VST3_CPACK_CONFIGURE_UNPARSED_ARGUMENTS}")
	endif()

    # The last component of each directory name is appended to the destination directory 
    # but a trailing slash may be used to avoid this because it leaves the last component empty.
    # https://cmake.org/cmake/help/v3.22/command/install.html#installing-directories
    if(DEFINED VST3_CPACK_CONFIGURE_PLUGIN_PRESETS_PATH)
        string(APPEND VST3_CPACK_CONFIGURE_PLUGIN_PRESETS_PATH "/")
    endif()

    # https://cmake.org/cmake/help/latest/module/CPack.html#variable:CPACK_PROJECT_CONFIG_FILE
    set(CPACK_PROJECT_CONFIG_FILE "${CMAKE_BINARY_DIR}/CMakeScripts/VST3CPackOptions.cmake")

    # Inno Setup specific settings
    # https://cmake.org/cmake/help/latest/cpack_gen/innosetup.html
    list(APPEND CPACK_INNOSETUP_CODE_FILES "${VST3_CPACK_SOURCE_DIR}/innosetup/VST3UpdateReadyMemo.pas")

    # CPACK_PACKAGE_VENDOR is mandatory for VST3
    if(NOT DEFINED CPACK_PACKAGE_VENDOR)
        set(CPACK_PACKAGE_VENDOR "VST3 Crowd")
        message(WARNING "[VCP] CPACK_PACKAGE_VENDOR not defined! The default is \"${CPACK_PACKAGE_VENDOR}\".")
    endif()

    # Platform specific config
    if(WIN32)
        set(VST3_CPACK_PLUGIN_PACKAGE_DESTINATION "VST3")
        set(VST3_CPACK_PLUGIN_PRESETS_DESTINATION "VST3 Presets/${CPACK_PACKAGE_VENDOR}/${PROJECT_NAME}")
        
        # For the uninstaller, e.g.: C:\Program Files\Company MyPlugin\
        set(CPACK_PACKAGE_INSTALL_DIRECTORY "${CPACK_PACKAGE_VENDOR} ${PROJECT_NAME}")
    elseif(APPLE)
        set(VST3_CPACK_PLUGIN_PACKAGE_DESTINATION "Library/Audio/Plug-ins/VST3")
        set(VST3_CPACK_PLUGIN_PRESETS_DESTINATION "Library/Audio/Presets/${CPACK_PACKAGE_VENDOR}/${PROJECT_NAME}")

        # Points to '/Applications' by default
        set(CPACK_PACKAGING_INSTALL_PREFIX "/")
    else()
        set(VST3_CPACK_PLUGIN_PACKAGE_DESTINATION ".")
        set(VST3_CPACK_PLUGIN_PRESETS_DESTINATION "VST3 Presets/${CPACK_PACKAGE_VENDOR}/${PROJECT_NAME}")
    endif()

    vst3_cpack_dump_vars()
    vst3_cpack_configure_directories()
endmacro()

macro(vst3_cpack_configure_directories)
    # plugin
    install(
        DIRECTORY   "${VST3_CPACK_CONFIGURE_PLUGIN_PACKAGE_PATH}"
        DESTINATION "${VST3_CPACK_PLUGIN_PACKAGE_DESTINATION}"
        COMPONENT   vst3plugin
        # CONFIGURATIONS Release
    )

    # presets
    install(
        DIRECTORY   "${VST3_CPACK_CONFIGURE_PLUGIN_PRESETS_PATH}"
        DESTINATION "${VST3_CPACK_PLUGIN_PRESETS_DESTINATION}"
        COMPONENT   vst3presets
        # CONFIGURATIONS Release
    )

    # Display both vst3plugin and vst3presets (optional) components
    set(CPACK_COMPONENTS_ALL vst3plugin)
    if(DEFINED VST3_CPACK_CONFIGURE_PLUGIN_PRESETS_PATH)
        list(APPEND CPACK_COMPONENTS_ALL vst3presets)
    endif()
endmacro()

macro (vst3_cpack_dump_vars)
    message(STATUS "[VCP] PLUGIN_NAME                             : ${PROJECT_NAME}")
    message(STATUS "[VCP] VST3_CPACK_CONFIGURE_PLUGIN_PACKAGE_PATH: ${VST3_CPACK_CONFIGURE_PLUGIN_PACKAGE_PATH}")
    message(STATUS "[VCP] VST3_CPACK_CONFIGURE_PLUGIN_PRESETS_PATH: ${VST3_CPACK_CONFIGURE_PLUGIN_PRESETS_PATH}")
    message(STATUS "[VCP] CPACK_PROJECT_CONFIG_FILE               : ${CPACK_PROJECT_CONFIG_FILE}")
    message(STATUS "[VCP] VST3_CPACK_PLUGIN_PACKAGE_DESTINATION   : ${VST3_CPACK_PLUGIN_PACKAGE_DESTINATION}")
    message(STATUS "[VCP] VST3_CPACK_PLUGIN_PRESETS_DESTINATION   : ${VST3_CPACK_PLUGIN_PRESETS_DESTINATION}")
endmacro()
