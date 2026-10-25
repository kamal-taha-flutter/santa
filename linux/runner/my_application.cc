#include "my_application.h"

#include <flutter_linux/flutter_linux.h>
#ifdef GDK_WINDOWING_X11
#include <gdk/gdkx.h>
#include <X11/Xatom.h>
#endif

#include "flutter/generated_plugin_registrant.h"

struct _MyApplication {
  GtkApplication parent_instance;
  char** dart_entrypoint_arguments;
};

G_DEFINE_TYPE(MyApplication, my_application, GTK_TYPE_APPLICATION)

// Sets _NET_WM_ICON directly. GTK/GDK can publish an empty icon property on
// XWayland even when an icon file was loaded successfully, so this guarantees
// that the taskbar and window switcher receive the branded artwork.
#ifdef GDK_WINDOWING_X11
static void set_x11_window_icon(GtkWindow* window, const gchar* icon_path) {
  GdkWindow* gdk_window = gtk_widget_get_window(GTK_WIDGET(window));
  if (gdk_window == nullptr || !GDK_IS_X11_WINDOW(gdk_window)) return;

  g_autoptr(GError) error = nullptr;
  g_autoptr(GdkPixbuf) source = gdk_pixbuf_new_from_file(icon_path, &error);
  if (source == nullptr) {
    g_warning("Failed to load _NET_WM_ICON from %s: %s", icon_path,
              error->message);
    return;
  }

  // A 256px RGBA icon is slightly larger than X11's maximum single
  // XChangeProperty request. 128px stays within the protocol limit and is
  // plenty for taskbars and window switchers, which scale as needed.
  g_autoptr(GdkPixbuf) scaled = nullptr;
  GdkPixbuf* pixbuf = source;
  const int source_width = gdk_pixbuf_get_width(source);
  const int source_height = gdk_pixbuf_get_height(source);
  if (source_width > 128 || source_height > 128) {
    scaled = gdk_pixbuf_scale_simple(source, 128, 128, GDK_INTERP_BILINEAR);
    if (scaled == nullptr) {
      g_warning("Failed to scale _NET_WM_ICON from %s", icon_path);
      return;
    }
    pixbuf = scaled;
  }

  const int width = gdk_pixbuf_get_width(pixbuf);
  const int height = gdk_pixbuf_get_height(pixbuf);
  const int rowstride = gdk_pixbuf_get_rowstride(pixbuf);
  const int channels = gdk_pixbuf_get_n_channels(pixbuf);
  const gboolean has_alpha = gdk_pixbuf_get_has_alpha(pixbuf);
  const guchar* pixels = gdk_pixbuf_get_pixels(pixbuf);

  const gsize count = 2 + (gsize)width * (gsize)height;
  g_autofree unsigned long* data = g_new(unsigned long, count);
  data[0] = (unsigned long)width;
  data[1] = (unsigned long)height;

  for (int y = 0; y < height; y++) {
    for (int x = 0; x < width; x++) {
      const guchar* pixel = pixels + y * rowstride + x * channels;
      const unsigned long red = pixel[0];
      const unsigned long green = pixel[1];
      const unsigned long blue = pixel[2];
      const unsigned long alpha = has_alpha ? pixel[3] : 255;
      data[2 + (gsize)y * (gsize)width + (gsize)x] =
          (alpha << 24) | (red << 16) | (green << 8) | blue;
    }
  }

  Display* xdisplay = GDK_DISPLAY_XDISPLAY(gdk_display_get_default());
  const Atom icon_atom = XInternAtom(xdisplay, "_NET_WM_ICON", False);
  XChangeProperty(xdisplay, gdk_x11_window_get_xid(gdk_window), icon_atom,
                  XA_CARDINAL, 32, PropModeReplace, (const unsigned char*)data,
                  (int)count);
  XFlush(xdisplay);
}
#endif

// Applies the bundled application icon to the GTK window and as a fallback
// for other windows owned by the process. On Wayland the compositor maps the
// application ID to the installed desktop entry; on X11 this also sets
// _NET_WM_ICON for the taskbar and window switcher.
static void set_window_icon(GtkWindow* window) {
  g_autofree gchar* executable_path = g_file_read_link("/proc/self/exe", nullptr);
  if (executable_path != nullptr) {
    g_autofree gchar* executable_dir = g_path_get_dirname(executable_path);
    g_autofree gchar* icon_path = g_build_filename(
        executable_dir, "data", "flutter_assets", "assets", "App%20Icon.png",
        nullptr);

    g_autoptr(GError) error = nullptr;
    gtk_window_set_default_icon_from_file(icon_path, nullptr);
    if (!gtk_window_set_icon_from_file(window, icon_path, &error)) {
      g_warning("Failed to set window icon from %s: %s", icon_path,
                error->message);
      g_clear_error(&error);
      gtk_window_set_icon_name(window, "santa");
    }
#ifdef GDK_WINDOWING_X11
    set_x11_window_icon(window, icon_path);
#endif
    return;
  }

  gtk_window_set_icon_name(window, "santa");
}

// Re-applies the icon after the window has been mapped; applying icon lists
// before mapping can leave X11's _NET_WM_ICON property empty.
static gboolean apply_window_icon_idle(gpointer user_data) {
  set_window_icon(GTK_WINDOW(user_data));
  return G_SOURCE_REMOVE;
}

// Called when first Flutter frame received.
static void first_frame_cb(MyApplication* self, FlView* view) {
  GtkWidget* window = gtk_widget_get_toplevel(GTK_WIDGET(view));
  gtk_widget_show(window);
  // Wait for the toplevel to map, then republish the window icon.
  g_timeout_add_full(G_PRIORITY_DEFAULT, 500, apply_window_icon_idle,
                     g_object_ref(window), g_object_unref);
}

// Implements GApplication::activate.
static void my_application_activate(GApplication* application) {
  MyApplication* self = MY_APPLICATION(application);
  GtkWindow* window =
      GTK_WINDOW(gtk_application_window_new(GTK_APPLICATION(application)));

  // Use a header bar when running in GNOME as this is the common style used
  // by applications and is the setup most users will be using (e.g. Ubuntu
  // desktop).
  // If running on X and not using GNOME then just use a traditional title bar
  // in case the window manager does more exotic layout, e.g. tiling.
  // If running on Wayland assume the header bar will work (may need changing
  // if future cases occur).
  gboolean use_header_bar = TRUE;
#ifdef GDK_WINDOWING_X11
  GdkScreen* screen = gtk_window_get_screen(window);
  if (GDK_IS_X11_SCREEN(screen)) {
    const gchar* wm_name = gdk_x11_screen_get_window_manager_name(screen);
    if (g_strcmp0(wm_name, "GNOME Shell") != 0) {
      use_header_bar = FALSE;
    }
  }
#endif
  const gchar* window_title = "سانتا | إدارة بيانات الأنشطة التجارية";
  if (use_header_bar) {
    GtkHeaderBar* header_bar = GTK_HEADER_BAR(gtk_header_bar_new());
    gtk_widget_show(GTK_WIDGET(header_bar));
    gtk_header_bar_set_title(header_bar, window_title);
    gtk_header_bar_set_show_close_button(header_bar, TRUE);
    gtk_window_set_titlebar(window, GTK_WIDGET(header_bar));
  } else {
    gtk_window_set_title(window, window_title);
  }

  gtk_window_set_default_size(window, 1280, 760);
  set_window_icon(window);

  g_autoptr(FlDartProject) project = fl_dart_project_new();
  fl_dart_project_set_dart_entrypoint_arguments(
      project, self->dart_entrypoint_arguments);

  FlView* view = fl_view_new(project);
  GdkRGBA background_color;
  // Match AppColors.canvas so the first frame never flashes black.
  gdk_rgba_parse(&background_color, "#F4F7F9");
  fl_view_set_background_color(view, &background_color);
  gtk_widget_show(GTK_WIDGET(view));
  gtk_container_add(GTK_CONTAINER(window), GTK_WIDGET(view));

  // Show the window when Flutter renders.
  // Requires the view to be realized so we can start rendering.
  g_signal_connect_swapped(view, "first-frame", G_CALLBACK(first_frame_cb),
                           self);
  gtk_widget_realize(GTK_WIDGET(view));

  fl_register_plugins(FL_PLUGIN_REGISTRY(view));

  gtk_widget_grab_focus(GTK_WIDGET(view));
}

// Implements GApplication::local_command_line.
static gboolean my_application_local_command_line(GApplication* application,
                                                  gchar*** arguments,
                                                  int* exit_status) {
  MyApplication* self = MY_APPLICATION(application);
  // Strip out the first argument as it is the binary name.
  self->dart_entrypoint_arguments = g_strdupv(*arguments + 1);

  g_autoptr(GError) error = nullptr;
  if (!g_application_register(application, nullptr, &error)) {
    g_warning("Failed to register: %s", error->message);
    *exit_status = 1;
    return TRUE;
  }

  g_application_activate(application);
  *exit_status = 0;

  return TRUE;
}

// Implements GApplication::startup.
static void my_application_startup(GApplication* application) {
  // MyApplication* self = MY_APPLICATION(object);

  // Perform any actions required at application startup.

  G_APPLICATION_CLASS(my_application_parent_class)->startup(application);
}

// Implements GApplication::shutdown.
static void my_application_shutdown(GApplication* application) {
  // MyApplication* self = MY_APPLICATION(object);

  // Perform any actions required at application shutdown.

  G_APPLICATION_CLASS(my_application_parent_class)->shutdown(application);
}

// Implements GObject::dispose.
static void my_application_dispose(GObject* object) {
  MyApplication* self = MY_APPLICATION(object);
  g_clear_pointer(&self->dart_entrypoint_arguments, g_strfreev);
  G_OBJECT_CLASS(my_application_parent_class)->dispose(object);
}

static void my_application_class_init(MyApplicationClass* klass) {
  G_APPLICATION_CLASS(klass)->activate = my_application_activate;
  G_APPLICATION_CLASS(klass)->local_command_line =
      my_application_local_command_line;
  G_APPLICATION_CLASS(klass)->startup = my_application_startup;
  G_APPLICATION_CLASS(klass)->shutdown = my_application_shutdown;
  G_OBJECT_CLASS(klass)->dispose = my_application_dispose;
}

static void my_application_init(MyApplication* self) {}

MyApplication* my_application_new() {
  // Set the program name to the application ID, which helps various systems
  // like GTK and desktop environments map this running application to its
  // corresponding .desktop file. This ensures better integration by allowing
  // the application to be recognized beyond its binary name.
  g_set_prgname(APPLICATION_ID);

  return MY_APPLICATION(g_object_new(my_application_get_type(),
                                     "application-id", APPLICATION_ID, "flags",
                                     G_APPLICATION_NON_UNIQUE, nullptr));
}
