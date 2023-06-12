{ pkgs, ... }:
let
  addons = pkgs.nur.repos.rycee.firefox-addons;
in {
  programs.firefox = {
    enable = true;
    extensions = with addons; [
      ublock-origin
      vimium
      darkreader
    ];
    profiles.npc = {
      settings = {
        /* ~/.mozilla/firefox/npc/prefs.js */
        "browser.startup.homepage" = "https://start.duckduckgo.com";
        "privacy.trackingprotection.enabled" = true;
        "general.smoothScroll" = false;
        # not working
        "browser.theme.content-theme" = 0;
        "browser.theme.toolbar-theme" = 0;
        "browser.download.dir" = "/tmp";
        "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
      };
    };
  };
}
