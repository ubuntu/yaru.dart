//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <yaru/yaru_plugin.h>

void fl_register_plugins(FlPluginRegistry* registry) {
  g_autoptr(FlPluginRegistrar) yaru_registrar =
      fl_plugin_registry_get_registrar_for_plugin(registry, "YaruPlugin");
  yaru_plugin_register_with_registrar(yaru_registrar);
}
