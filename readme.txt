           ___     _   _
          | _ \   | \_/ |
          |  _/   |  _  |
          | |     | | | |
          |_| OKE |_| |_| INI
          -------------------
             Version 0.5.4

  Homebrew-emulator for Pokémon-Mini!

  Download lastest version in:
  http://code.google.com/p/pokemini/

  For hardware documentation, visit:
  http://wiki.sublab.net/index.php/Pokemon_Mini

> Keys & Information:

  To include real BIOS, place "bios.min" on the emulator's directory.
  When no "bios.min" is present, emulator will use Pokemon-Mini FreeBIOS.

  Pokémon-Mini     PC Keys
  ----------------------------
  D-PAD Left       Arrow Left
  D-PAD Right      Arrow Right
  D-PAD Up         Arrow Up
  D-PAD Down       Arrow Down
  Key A            Keyboard X
  Key B            Keyboard Z
  Key C            Keyboard S or C
  Power Button     Keyboard E
  Shock Detector   Keyboard A
  ----------------------------
  UI Menu          Keyboard Esc

  F9 will capture the screen and save as "snap_(sequence number).bmp"

  F10 can toggle between Fullscreen and Windowed.

  F11 will disable/enable speed throttle

  TAB can be hold to temporary disable speed throttle

> Supported multicarts:

  Type 0 - Disabled (Commercial, Prototype)
    Read only

  Type 1 - Normal 512KB Flash (AM29LV040B)
    Read, Erase, Write, Banking and Manufacturer ID

  Type 2 - Lupin's 512KB Flash (AM29LV040B)
    Read, Erase, Write, Banking and Manufacturer ID

> Command-Line:

  Usage:
  PokeMini [Options] rom.min

  Options:
  -freebios              Force FreeBIOS
  -bios otherbios.min    Load BIOS
  -noeeprom              Discard EEPROM data
  -eeprom pokemini.eep   Load/Save EEPROM file
  -eepromshare           Share EEPROM to all ROMs (default)
  -noeepromshare         Each ROM will use individual EEPROM
  -nostate               Discard State data (default)
  -state pokemini.sta    Load/Save state file
  -nortc                 No RTC
  -statertc              RTC time difference in savestates
  -hostrtc               RTC match the Host clock (def)
  -nosound               Disable sound
  -sound                 Same as -soundpiezo (def)
  -sounddirect           Use timer 3 directly for sound (default)
  -soundemulate          Use sound circuit emulation
  -sounddirectpwm        Same as direct, can play PWM samples
  -nopiezo               Disable piezo speaker filter
  -piezo                 Enable piezo speaker filter (def)
  -scanline              50% Scanline LCD filter
  -dotmatrix             LCD dot-matrix filter (def)
  -nofilter              No LCD filter
  -2shades               LCD Mode: No mixing
  -3shades               LCD Mode: Grey emulation
  -analog                LCD Mode: Pretend real LCD (default)
  -fullbattery           Emulate with a full battery (default)
  -lowbattery            Emulate with a weak battery
  -palette n             Select palette for colors (0 to 15)
  -rumblelvl 3           Rumble level (0 to 3)
  -nojoystick            Disable joystick (def)
  -joystick              Enable joystick
  -joyid 0               Set joystick ID
  -nomulticart           Disable multicart support (def)
  -multicart 1           Multicart support (type 1 only)
  -custom1light 0xFFFFFF Palette Custom 1 Light
  -custom1dark 0x000000  Palette Custom 1 Dark
  -custom2light 0xFFFFFF Palette Custom 2 Light
  -custom2dark 0x000000  Palette Custom 2 Dark
  -synccycles 8          Number of cycles per hardware sync.

  Only on SDL platform:
  -dumpsound sound.wav   Dump sound into a WAV file
  -windowed              Display in window (default)
  -fullscreen            Display in fullscreen
  -zoom n                Zoom display: 1 to 4 (def 4)
  -bpp n                 Bits-Per-Pixel: 16 or 32 (def 16)

  Only on Debugger platform:
  -autorun 0             Autorun, 0=Off, 1=Full, 2=Dbg+Snd, 3=Dbg
  -windowed              Display in window (default)
  -fullscreen            Display in fullscreen
  -zoom n                Zoom display: 1 to 4 (def 4)
  -bpp n                 Bits-Per-Pixel: 16 or 32 (def 16)
  

> System requirements:

  No sound:
  Pentium III 733 Mhz or better recommended.

  With sound:
  Pentium IV 1.7 Ghz or better recommended.

  Note: Performance tests were based on 0.4.0 version

> History:

  -: 0.5.4 Changes :-
  Fixed savestates load/save
  Minor changes
  PSP Only:
    Timezone is now handled correctly

  -: 0.5.3 Changes :-
  Fixed command-line parsing which caused problems with lastest GCC
  Directory '.' no longer listed
  Configurations now save the directory of the last ROM loaded
  Improved support on color PRC (now works on framebuffer and LCD)
  Dreamcast Only:
    Added read/write VMU support
    EEPROM write disabled by default
  Debugger Only:
    Fixed "Add watchpoint at..." in Memory Viewer
    Added symbols list window
    Added run trace window
    Added "Go to cartridge IRQ" with ability to decode the address
    Middle and Right click now set breakpoint/watchpoint
    Go to address/IRQ now highlight the location
    Added autorun .min after load
    Fixed offset of CE jump instructions
  NDS Only: Removed real battery status

  -: 0.5.2 Changes :-
  Opening .minc files now opens the linked .min files
  More accurant PRC timing and triggering
  Minor changes
  Debugger Only:
    Recent ROMs list
    Drag & Drop ROM files support
    Added file association to .min and .minc files
    Moved PRC Counter from Timers Window to Misc. Window
    Added more special registers for printing and controlling the debug output
    Reorganized the menu
    Improved the memory content components
    Added 16-bits memory filler into memory viewer
    All viewers and main window position & size are now saved
  Win32 Only: 
    Fixed command-lines and closing code
    Recent ROMs list
    Drag & Drop ROM files support
    Added "Pause when inactive" window option
    Added file association to .min and .minc files

  -: 0.5.1 Changes :-
  Relative files are now launched from current directory
  Fixed notification message display in 32bpp
  Added 50% Scanline LCD filter
  New Tools (Available in Debugger package):
    PokeMini Image Converter
    PokeMini Music Converter
  Debugger only:
    F1 shortcut for documentation
    Improved external launcher
    IRQ Window "Frames in single-row" initialization fixed
    Minimized windows won't be rendered now
    Added "Character Set -> From file..." in Memory viewer
    Added "Memory data" in Memory viewer with Import, Export,
      Copy and Fill operations.
  Win32 Only: Fixed DirectDraw surface pitch

  -: 0.5.0 Changes :-
  Debugger is now complete!
  Reordered menu items better
  Added Dingux platform (Thanks coccijoe for the port src code)
  Fixed issue of sound going out of sync
  Separated piezo filtering (now works with any sound engine)
  Fixed result of SUB instruction with decimal mode
  Fixed PRC rate divider
  Corrected some options in configurations file
  Multicart support
  Made sure shared EEPROM and cfg files are only saved on emulator's
   executable directory
  Added "Sync cycles" option that allow to trade between performance and
   accurancy, higher value can speed up emulation but may cause problems
  Pressing Left/Right while browsing will now page up/down, selecting
   drive is now C+Left and C+Right
  Unofficial colors palette changed (but still backward compatible)
  New zooms: 5x (480x320) and 6x (576x384)
  Loading ROM from ZIP package is now supported
  More palettes and 2 custom ones, they can be edited by pressing A
  Win32 platform is now fixed and updated
  Joystick can now be re-defined in portable devices
  SDL Only: Keyboard can now be re-defined under "Platform..."
  Dreamcast Only: PAL/NTSC can now be selected under "Platform..."
  NDS Only: Added FPS counter and rumble pak level adjustment
  PSP Only: Zoom from 1x to 4x can now be changed under "Platform..."

  -: 0.4.5 Changes :-
  Fixed interrupt flag status after interrupt jump/call
  Added "Generated", "Direct PWM" and "PWM+Filter" sound modes
    Generated  - Mode used in slow platforms
    Direct PWM - Same as direct but with ability to play PWM raw sounds
    PWM+Filter - Direct PWM with filtering to simulate PM's piezo speaker
  LCD update now when "dirty" instead of PRC rate counter match
  Unofficial colors information structure changed to lower memory usage
  Support for 4x4 attributes in unofficial colors
  Added "Reload colors info..." to reload the .minc file
  Soft reset now supported, changing rom won't reset clock
  FreeBIOS 1.2: Display status and improved compatibility
  SDL Only: Added joystick support (disabled by default)
  Joystick can be enabled under "Platform..." -> "Define Joystick..."
  SDL Only: Color depth can be changed between 16bpp and 32bpp
  Wiz Only: Fixed crash when sound disabled and added SDL port (wizsdl)
  NDS, Wiz and PSP Only: Battery can be setup to reflect real battery
  Source Only: Added some simplified platforms to help porting

  -: 0.4.4 Changes :-
  Fixed POPA/POPAX timings (thanks asterick).
  Added support to read/write configurations @ 'pokemini.cfg'.
  Load/save state are now working!
  Added support for unshared EEPROM files (Each ROM can have his own EEPROM).
  SDL Only: Zoom can now be changed on the fly under "Platform..."
  Added more options.

  -: 0.4.3 Changes :-
  Some fixes.
  Added zoom support for SDL platform (1x, 2x, 3x or 4x).
  Added Dreamcast platform.
  Fullscreen toggle works now on Windows.
  Added emulated sound support for all platforms.
  Improved UI.

  -: 0.4.2 Changes :-
  Palette support in SDL.
  Rumble now shake the display up & down.
  Added Wiz platform.
  Fixed EEPROM access.
  Fixed signed jump/call instructions.
  Removed load/save state until a problem is solved.
  Added unofficial colors support into games!

  -: 0.4.1 Changes :-
  Minor changes.
  Audio dumping/capture is now WAV format.

  -: 0.4.0 Changes :-
  Complete rewrite, source code seems very portable.
  Added FreeBIOS, a public domain BIOS that try to behave like the real BIOS.
  Added SDL and some platforms.

> License GPLv3 (emulator and tools):

PokeMini - Pokémon-Mini Emulator
Copyright (C) 2013  JustBurn

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

> Greetings & Links:

  Thank's to p0p, Dave|X, Onori
  goldmomo, asterick, DarkFader, Agilo
  MrBlinky, Wa, Lupin and everyone at
  #pmdev on IRC EFNET!
  Questions and Bugs reports are welcome!

  PokeMini webpage:
  http://code.google.com/p/pokemini/

  Pokemon-Mini Hardware:
  http://wiki.sublab.net/index.php/Pokemon_Mini

  Pokémon-mini.net:
  http://www.pokemon-mini.net/

  MEGA - Museum of Electronic Games & Art:
  http://m-e-g-a.org/

  Minimon (other Pokemon-Mini emulator):
  http://www.sublab.net/projects/minimon/

  DarkFader Pokemon-Mini webpage:
  http://darkfader.net/pm/

  Agilo's Weblog:
  http://www.agilo.nl/

  Dox's webpage:
  http://slanina.pl/?page_id=67
