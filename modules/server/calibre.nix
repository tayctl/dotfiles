{ ... }: {
  services.calibre-web = {
    enable = true;
    listen.ip = "127.0.0.1";
    listen.port = 8083;
    options = {
      calibreLibrary = "/home/main/calibre/library";
      enableBookUploading = true;
    };
    user = "main";
    group = "users";
  };
  # Create the library once: calibredb add --library-path ~/calibre/library --empty
}
