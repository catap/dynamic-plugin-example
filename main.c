#include <dlfcn.h>
#include <stdio.h>

#define PLUGIN "./plugin"
#define PLUGIN_FUNC "plugin_func"

int main(int argc, char **argv) {
  void (*plugin)();
  void *handle;
  char *error;

  handle = dlopen(PLUGIN, RTLD_LAZY);
  if (!handle) {
    printf("dlopen(\"%s\"): %s\n", PLUGIN, dlerror());
    return -1;
  }
  
  plugin = dlsym(handle, "plugin_func");
  if ((error = dlerror()) != NULL)  {
    printf("dlsym(\"%s\"): %s\n", PLUGIN_FUNC, error);
    return -2;
  }
  
  (*plugin)();
  
  return 0;
}