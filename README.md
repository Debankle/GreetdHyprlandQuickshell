# Hyprland + Quickshell Login Greeter for Greetd

This project is a proof-of-concept custom login greeter built using greetd, Hyprland, and Quickshell. It demonstrates how a restricted greeter session can launch a Wayland compositor and render a fully customizable graphical login interface using QML.

The goal is to provide a lightweight and flexible alternative to traditional display managers, while showcasing how greetd can be extended with modern Wayland tooling.

## How it works

1. greetd launches a restricted `greeter` user session.
2. This session starts a minimal Hyprland instance with a locked-down configuration (no keybindings, terminal access or admin permissions).
3. Hyprland automatically launches a Quickshell interface via `exec-once`.
4. Quickshell connects to greetd’s authentication API and presents a graphical login UI.
5. After successful authentication, the greeter session exits and greetd starts a new Hyprland session for the authenticated user.

All Hyprland and greetd logs in the greeter session are redirected to `/dev/null` to keep the interface visually clean. However this does not fix the few second delay while the temporary Hyprland session is torn down and the user environment is started. I'm sure this is fixable, I just haven't gotten around to working out how to hide this.

## Features

- Custom Quickshell login UI
- Hyprland environment for display manager
- Simple installation script
- Minimal dependencies
- Minimal locked-down greeter environment
- Customisable to the limits of Hyprland and Quickshell

## Dependencies

- greetd
- Hyprland
- Quickshell
- seatd (device access for the greeter session)
- systemd
- Linux (tested on Arch Linux)

## Installation

To install the necessary configs, clone the repository and then run the install script as sudo. This will back up existing files in that directory and copy these there. Otherwise manually copy the files to any temporary place you please, with the constraint that the greeter user can read them.

``` bash
git clone https://github.com/Debankle/GreetdHyprlandQuickshell.git
cd GreetdHyprlandQuickshell
sudo ./install.sh
```

Then to ensure the necessary services are running:

``` bash
systemctl enable --now greetd
systemctl enable --now seatd
```

## License

This is licensed under the MIT license

## Credits

This was inspired by the rice done by [u/ElninoMerino](https://www.reddit.com/r/unixporn/comments/1quzoqw/hyprland_ctos_my_first_rice/), which gave me the idea to attempt this myself, in a much simpler way.
