# BCON-Kiosk

General and prize kiosks for the BCON RFID Arcade project.

## Overview

The kiosks play a critical role within the arcade to handle player interaction with backend data. There are two types of kiosks, each of which fulfills different roles and requirements within the arcade. Both kiosks were designed with the mindset of being deployed on a large, touchscreen interface to provide ease of use and control for players in the arcade.

The project is built against the [Qt Open Source](https://qt.io) framework, making it easily portable across platforms.

### Common Functionality

- Checking and displaying player profile information (ID, tokens, tickets, screen name).
- Real-time data updates via publish-subscribe mechanisms.

### General Kiosk

- Checking and displaying gameplay statistics.
- Adding tokens to a player's profile (currently simulating a real transaction).
- Updating a player's screen name.

### Prize Kiosk

- Checking and displaying the arcade prize catalog
- Displaying detailed prize information (name, description, image, quantity, ticket cost).
- Redeeming prizes for tickets.

## Prerequisites

- [Qt Open Source](https://qt.io/download) (5.12.0 or later preferred)

	- Download and execute the installer for your platform (macOS or Linux preferred).
	- To run the project, _at least_ the base installation (i.e. "macOS" or "Desktop gcc" for Linux) and the Virtual Keyboard should be checked off when expanding the desired installation version.
	- The Qt Creator IDE will be installed by default.

- [libBCONNetwork](https://github.com/teambcon/libBCONNetwork) (project submodule)

	- Before the project can built, its submodule dependency must be.
	- Ensure Qt's binary directory is in the `PATH` environment variable (i.e. `~/Qt/5.12.0/clang_64/bin` for macOS)
	- Execute the build script for your platform inside of the library _build_ directory.
	- The dynamic library will be created in a platform-dependent directory inside _libBCONNetwork/libs_.

## Building the Kiosk

Once the library dependencie has been built and installed as described above, the kiosk can be built with `qmake` and `make` (typically through Qt Creator).

To build without using the IDE:

```sh
mkdir build
cd build
qmake ../BCON-Kiosk.pro
make
```

## Running the Kiosk

### Command Line Options

| Option | Description |
| ------ | ----------- |
| `-h`, `--help` | Displays help options. |
| `-v`, `--version` | Displays version information. |
| `-p`, `--prize` | Load as a prize kiosk (leave unset for general). |
| `-s`, `--server <IP:Port>` | Address of the backend server to connect to. |
| `-n`, `--nonfc` | Do not use NFC functionality (for debugging). |

#### Examples

Run the general kiosk against a local backend:

```
./BCON-Kiosk --server http://localhost:3000
```

Run the prize kiosk against a local backend:

```
./BCON-Kiosk --server http://localhost:3000 --prize
```

### Dynamic Library Path

When running from command line, it may be necessary to resolve the dynamic library path for locating the libBCONNetwork library. On macOS and Linux, this is accomplished by exporting the `DYLD_LIBRARY_PATH` and `LD_LIBRARY_PATH` environment variables, respectively for running the project.

macOS Example:

```sh
export DYLD_LIBRARY_PATH=path/to/BCON-Kiosk/libBCONNetwork/lib/macOS:$DYLD_LIBRARY_PATH
```

### NFC Reader

To actually use the kiosk, the NFC reader supported by libBCONNetwork must be connected before running. Otherwise, the kiosk will never proceed past the waiting screen. For more details, see the libBCONNetwork documentation.

