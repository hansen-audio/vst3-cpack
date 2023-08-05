# VST3 CPack

**VST3 CPack** uses CPack (part of CMake) to create VST3 plug-in installers for Windows, macOS and Linux. 

## Use as a subdirectory

Using CMake's ```FetchContent``` module allows you to easily integrate **VST3 CPack** into your existing VST3 project.

```cmake
include(FetchContent)

FetchContent_Declare(
    vst3-cpack
    GIT_REPOSITORY https://github.com/hansen-audio/vst3-cpack.git
    GIT_TAG main
)

FetchContent_MakeAvailable(vst3-cpack)
```

Insert the following lines to the end of the root ```CMakeLists.txt``` of your VST3 project.

```cmake
get_target_property(PLUGIN_PACKAGE_PATH MyPlugin SMTG_PLUGIN_PACKAGE_PATH)

vst3_cpack_configure(
    PLUGIN_PACKAGE_DIRECTORY "${PLUGIN_PACKAGE_PATH}"
    PLUGIN_PRESETS_DIRECTORY "/path/to/MyPlugin/presets # Optional
)
include(CPack)
```

### Get more advanced with CPack
You can still use CPack as usual and set CPack variables.

```cmake
...
set(CPACK_PACKAGE_VENDOR "My Company)
set(CPACK_RESOURCE_FILE_LICENSE ${PROJECT_SOURCE_DIR}/LICENSE)
vst3_cpack_configure(
    PLUGIN_PACKAGE_DIRECTORY "/path/to/build/Release/MyPlugin.vst3"
    PLUGIN_PRESETS_DIRECTORY "/path/to/MyPlugin/presets # Optional
)
include(CPack)
```

## Execute CPack on command line

**VST3 CPack** is tested with following CPack geneartors:

* Windows: ```INNOSETUP``` and ```NSIS```
* macOS: ```productbuild```
* Linux: ```TGZ```

Other CPack generators might work as well.

Execute CPack inside the CMake binary directory of your VST3 project. 

```console
cpack -G INNOSETUP .
```

## Prepare Windows for VST3 CPack

Use ```winget``` command line tool on Windows to install **Inno Setup** (https://jrsoftware.org) and/or **NSIS** (https://nsis.sourceforge.io).

```console
winget install JRSoftware.InnoSetup
winget install NSIS.NSIS
```