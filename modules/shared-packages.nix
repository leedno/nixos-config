{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    #mullvad-browser
    via
    typioca
    sqlite
    nodemon
    sqlitebrowser
    postman
  ];
}
