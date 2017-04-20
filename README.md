# DCRS-OS
Operating system version of DCRS, based in Ubuntu modified by [@mkg20001](https://github.com/mkg20001).

# Building
To only build the dcrs main snap run `snapcraft` (assuming you have it installed) and enjoy.

# Image Building

To build the dcrs-core image run `make ID=ubuntu-developer-account-id KEY=default CHANNEL=edge`

This will require some things:
 - An Ubuntu SSO Account
 - A key which is registered in your account
 - An account id (requires at least 1 snap upload)
 - Ubuntu image: `snap install ubuntu-image --beta --devmode`
 - Snapcraft
 - At least 6gb free disk space
