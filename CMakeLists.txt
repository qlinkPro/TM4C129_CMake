cmake_minimum_required(VERSION 3.10)

if(NOT DEFINED CMAKE_TOOLCHAIN_FILE)
    set(CMAKE_TOOLCHAIN_FILE "${CMAKE_SOURCE_DIR}/toolchain.cmake" CACHE FILEPATH "Toolchain file")
endif()

project(Blinky)

add_executable(
        ${PROJECT_NAME}
        src/blinky.c
        board/startup_gcc.c
)

set_target_properties(${PROJECT_NAME} PROPERTIES SUFFIX ".elf")

set_property(TARGET ${PROJECT_NAME} PROPERTY C_STANDARD 11)
set_property(TARGET ${PROJECT_NAME} PROPERTY C_EXTENSIONS ON)

target_include_directories(${PROJECT_NAME} PRIVATE
        ${PROJECT_SOURCE_DIR}/inc
        ${PROJECT_SOURCE_DIR}/driverlib
)

target_link_libraries(${PROJECT_NAME} PRIVATE ${CMAKE_SOURCE_DIR}/driverlib/libdriver.a)

target_compile_options(${PROJECT_NAME} PRIVATE
        -mthumb
        -mcpu=cortex-m4
        -mfloat-abi=hard
        -Wall
        -ffreestanding
        -fno-builtin-memcpy
        $<$<CONFIG:Debug>:-Og -g3 -fno-omit-frame-pointer>
)

target_link_options(${PROJECT_NAME} PRIVATE
        -mthumb
        -mcpu=cortex-m4
        -mfloat-abi=hard
        -nostdlib
        -T ${CMAKE_SOURCE_DIR}/board/tm4c129.ld
)

add_custom_command(
        TARGET ${PROJECT_NAME}
        POST_BUILD
        COMMAND ${CMAKE_OBJCOPY} -O binary
        $<TARGET_FILE:${PROJECT_NAME}>
        $<TARGET_FILE_DIR:${PROJECT_NAME}>/$<TARGET_FILE_BASE_NAME:${PROJECT_NAME}>.bin
)
