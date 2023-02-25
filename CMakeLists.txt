cmake_minimum_required(VERSION 3.15.1)

project(SideKit LANGUAGES C Swift)

add_library(CSideKit
    Sources/CSideKit/NSError+ALTServerError.h
    Sources/CSideKit/NSError+ALTServerError.m
)

add_library(SideKit
    Sources/SideKit/Extensions/ALTServerError+Conveniences.swift
    Sources/SideKit/Extensions/Result+Conveniences.swift

    Sources/SideKit/Server/Connection.swift
    Sources/SideKit/Server/NetworkConnection.swift
    Sources/SideKit/Server/Server.swift
    Sources/SideKit/Server/ServerConnection.swift
    Sources/SideKit/Server/ServerManager.swift
    Sources/SideKit/Server/ServerProtocol.swift

    Sources/SideKit/Types/CodableServerError.swift
)

target_link_libraries(SideKit PRIVATE CSideKit)

set_property(TARGET SideKit PROPERTY XCODE_ATTRIBUTE_SWIFT_VERSION "5.0")

# Make CSideKit's modulemap available to SideKit
set_property(TARGET SideKit PROPERTY XCODE_ATTRIBUTE_SWIFT_INCLUDE_PATHS "${CMAKE_CURRENT_SOURCE_DIR}/Sources/CSideKit")

# Add binary dir to interface include path to make Swift header accessible to targets using SideKit
target_include_directories(SideKit INTERFACE ${CMAKE_CURRENT_BINARY_DIR})

# Copy generated Swift header to binary dir
add_custom_command(TARGET SideKit
                   POST_BUILD
                   COMMAND cp $DERIVED_SOURCES_DIR/SideKit-Swift.h ${CMAKE_CURRENT_BINARY_DIR}
)
