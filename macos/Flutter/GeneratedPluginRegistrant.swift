//
//  Generated file. Do not edit.
//

import FlutterMacOS
import Foundation

import bitsdojo_window_macos
import device_info_plus
import irondash_engine_context
import package_info_plus
import path_provider_foundation
import super_native_extensions
import system_tray

func RegisterGeneratedPlugins(registry: FlutterPluginRegistry) {
  BitsdojoWindowPlugin.register(with: registry.registrar(forPlugin: "BitsdojoWindowPlugin"))
  DeviceInfoPlusMacosPlugin.register(with: registry.registrar(forPlugin: "DeviceInfoPlusMacosPlugin"))
  IrondashEngineContextPlugin.register(with: registry.registrar(forPlugin: "IrondashEngineContextPlugin"))
  FPPPackageInfoPlusPlugin.register(with: registry.registrar(forPlugin: "FPPPackageInfoPlusPlugin"))
  PathProviderPlugin.register(with: registry.registrar(forPlugin: "PathProviderPlugin"))
  SuperNativeExtensionsPlugin.register(with: registry.registrar(forPlugin: "SuperNativeExtensionsPlugin"))
  SystemTrayPlugin.register(with: registry.registrar(forPlugin: "SystemTrayPlugin"))
}
