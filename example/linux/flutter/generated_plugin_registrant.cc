//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <handy_window/handy_window_plugin.h>
#include <screen_retriever/screen_retriever_plugin.h>
#include <window_manager/window_manager_plugin.h>
#include <yaru/yaru_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) handy_window_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "HandyWindowPlugin");
  handy_window_plugin_register_with_registrar(handy_window_registrar);
  g_autoptr(FlPluginRegistrar) screen_retriever_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "ScreenRetrieverPlugin");
  screen_retriever_plugin_register_with_registrar(screen_retriever_registrar);
  g_autoptr(FlPluginRegistrar) window_manager_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "WindowManagerPlugin");
  window_manager_plugin_register_with_registrar(window_manager_registrar);
  g_autoptr(FlPluginRegistrar) yaru_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "YaruPlugin");
  yaru_plugin_register_with_registrar(yaru_registrar);
}
