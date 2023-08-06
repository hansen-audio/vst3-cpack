# VST3 CPack

**VST3 CPack** uses CPack (part of CMake) to create VST3 plugin installers for Windows, macOS and Linux. It gives you a good starting point for a simple installer that you can extend by your own components and scripts.

## Use as a subdirectory

Using CMake's ```FetchContent``` module allows you to easily integrate **VST3 CPack** into your existing VST3 ```project```.

```cmake
include(FetchContent)

FetchContent_Declare(
    vst3-cpack
    GIT_REPOSITORY https://github.com/hansen-audio/vst3-cpack.git
    GIT_TAG main
)

FetchContent_MakeAvailable(vst3-cpack)
```

Add the following lines to the end of the ```CMakeLists.txt``` which contains the ```project``` command at the beginning. In most cases this is the root ```CMakeLists.txt```.

```cmake
get_target_property(PLUGIN_PACKAGE_PATH MyPlugin SMTG_PLUGIN_PACKAGE_PATH)
vst3_cpack_configure(
    PLUGIN_PACKAGE_PATH "${PLUGIN_PACKAGE_PATH}"
    PLUGIN_PRESETS_PATH "/path/to/MyPlugin/presets" # Optional
)

include(CPack)
```

> ```include(CPack)``` must be called at the very end!

### Get more advanced with CPack

You can still use CPack as usual and set CPack variables.

```cmake
...
set(CPACK_PACKAGE_VENDOR "My Company")
set(CPACK_RESOURCE_FILE_LICENSE ${PROJECT_SOURCE_DIR}/LICENSE)
vst3_cpack_configure(
    PLUGIN_PACKAGE_PATH "/path/to/build/Release/MyPlugin.vst3"
    PLUGIN_PRESETS_PATH "/path/to/MyPlugin/presets" # Optional
)

include(CPack)
```

## Execute CPack on command line

**VST3 CPack** is tested with following CPack geneartors:

* Windows: ```INNOSETUP``` and ```NSIS```
* macOS: ```productbuild```
* Linux: ```TGZ```

Other CPack generators might work as well. If you find a generator which is not working as expected, report an issue or create a pull request.

Execute CPack inside the CMake binary directory of your VST3 ```project```. 

```console
cpack -C Release -G INNOSETUP .
```

> You can also use ```-C Debug``` to pickup the debug build of your VST3 plugin for testing purpose.

## Prepare Windows for VST3 CPack

Use ```winget``` command line tool on Windows to install **Inno Setup** (https://jrsoftware.org) and/or **NSIS** (https://nsis.sourceforge.io).

```console
winget install JRSoftware.InnoSetup
winget install NSIS.NSIS
```