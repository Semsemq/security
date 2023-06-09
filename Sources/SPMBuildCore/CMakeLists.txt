# This source file is part of the Swift open source project
#
# Copyright (c) 2014 - 2022 Apple Inc. and the Swift project authors
# Licensed under Apache License v2.0 with Runtime Library Exception
#
# See http://swift.org/LICENSE.txt for license information
# See http://swift.org/CONTRIBUTORS.txt for Swift project authors

add_library(SPMBuildCore
  BinaryTarget+Extensions.swift
  BuildParameters.swift
  BuildSystem.swift
  BuildSystemCommand.swift
  BuildSystemDelegate.swift
  BuiltTestProduct.swift
  PluginContextSerializer.swift
  PluginInvocation.swift
  PluginMessages.swift
  PluginScriptRunner.swift
  PrebuildCommandResult.swift
  Triple+Extensions.swift
  XCFrameworkMetadata.swift)
# NOTE(compnerd) workaround for CMake not setting up include flags yet
set_target_properties(SPMBuildCore PROPERTIES
  INTERFACE_INCLUDE_DIRECTORIES ${CMAKE_Swift_MODULE_DIRECTORY})
target_link_libraries(SPMBuildCore PUBLIC
  TSCBasic
  TSCUtility
  Basics
  PackageGraph)


if(USE_CMAKE_INSTALL)
install(TARGETS SPMBuildCore
  ARCHIVE DESTINATION lib
  LIBRARY DESTINATION lib
  RUNTIME DESTINATION bin)
endif()
set_property(GLOBAL APPEND PROPERTY SwiftPM_EXPORTS SPMBuildCore)
