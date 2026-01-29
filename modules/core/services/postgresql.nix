{
  config,
  pkgs,
  ...
}: {
  services.postgresql = {
    enable = true;
    package = pkgs.postgresql_16;
    # This automatically creates the database for your course
    ensureDatabases = ["nodemovies"];
    enableTCPIP = true;
    authentication = pkgs.lib.mkOverride 10 ''
      #type database  user  address     method
      local all       all               trust
      host  all       all   127.0.0.1/32  trust
      host  all       all   ::1/128       trust
    '';
  };
}
