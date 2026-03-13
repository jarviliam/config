cmake_minimum_required(VERSION 3.20)

project(MyCppProject
    VERSION 0.1.0
    LANGUAGES CXX
)
# ---- Options ----
option(BUILD_TESTING "Build tests" ON)
option(BUILD_WARNINGS_AS_ERRORS "Treat compiler warnings as errors" OFF)

# ---- Global compiler configuration ----
set(CMAKE_CXX_STANDARD 20)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

if (MSVC)
    set(WARN_FLAGS /W4)
else()
    set(WARN_FLAGS -Wall -Wextra -Wpedantic -Wconversion -Wsign-conversion)
endif()

add_library(project_warnings INTERFACE)
target_compile_options(project_warnings INTERFACE ${WARN_FLAGS})
if (BUILD_WARNINGS_AS_ERRORS)
    if (MSVC)
        target_compile_options(project_warnings INTERFACE /WX)
    else()
        target_compile_options(project_warnings INTERFACE -Werror)
    endif()
endif()

# ---- Main executable ----
# Default layout:
#   src/main.cpp
#   include/   (for headers, optional)
file(GLOB_RECURSE PROJECT_SOURCES CONFIGURE_DEPENDS src/*.cpp)
if (PROJECT_SOURCES)
    add_executable(${PROJECT_NAME} ${PROJECT_SOURCES})
    target_link_libraries(${PROJECT_NAME} PRIVATE project_warnings)
    target_include_directories(${PROJECT_NAME}
        PRIVATE
            ${CMAKE_CURRENT_SOURCE_DIR}/include
    )
endif()

# ---- Tests ----
if (BUILD_TESTING)
    include(CTest)
    if (BUILD_TESTING)
        # Expect tests in tests/*.cpp using GTest
        add_library(project_test_warnings INTERFACE)
        target_link_libraries(project_test_warnings INTERFACE project_warnings)
        find_package(GTest QUIET)
        if (GTest_FOUND)
            enable_testing()
            file(GLOB_RECURSE TEST_SOURCES CONFIGURE_DEPENDS tests/*.cpp)
            foreach(test_src IN LISTS TEST_SOURCES)
                get_filename_component(test_name "${test_src}" NAME_WE)
                add_executable(${test_name} "${test_src}")
                target_link_libraries(${test_name}
                    PRIVATE
                        project_test_warnings
                        GTest::gtest_main
                )
                add_test(NAME ${test_name} COMMAND ${test_name})
            endforeach()
        else()
            message(STATUS "GTest not found; tests will not be built.")
        endif()
    endif()
endif()
