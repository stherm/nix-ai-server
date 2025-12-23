# TODO: how to overlay lib?
{
  # TODO: mkReverseProxy

  mkInternalReverseProxy = addr: {
    listen = [
      {
        # inherit addr; # FIXME: IP binding not working?
        addr = "0.0.0.0";
        port = 80;
      }
    ];
  };
}
