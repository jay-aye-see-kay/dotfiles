# My dotfiles/config files

## Usage

This repo is a GNU stow "package", clone this repo into your home directory and run `stow main`.

## Firefox userChrome

link user css with the following command(s)

```sh
ln -s $PWD/ff-user-chrome/ ~/.mozilla/firefox/<profile_id>/chrome
```

- The path to the current profile can be found in Firefox's `about:support` page
- `toolkit.legacyUserProfileCustomizations.stylesheets` must be enabled in `about:config`
