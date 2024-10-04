package funkin.api.windows;

/**
 * taken from grafex lol
 */
#if windows
@:buildXml('
<target id="haxe">
    <lib name="dwmapi.lib" if="windows" />
    <lib name="shell32.lib" if="windows" />
    <lib name="gdi32.lib" if="windows" />
    <lib name="ole32.lib" if="windows" />
    <lib name="uxtheme.lib" if="windows" />
</target>
')
// majority is taken from microsofts doc
@:cppFileCode('
#include "mmdeviceapi.h"
#include "combaseapi.h"
#include <iostream>
#include <Windows.h>
#include <cstdio>
#include <tchar.h>
#include <dwmapi.h>
#include <winuser.h>
#include <Shlobj.h>
#include <wingdi.h>
#include <shellapi.h>
#include <uxtheme.h>
')
class WinAPI
{
  @:functionCode('
        int darkMode = enable ? 1 : 0;
        HWND window = GetActiveWindow();
        if (S_OK != DwmSetWindowAttribute(window, 19, &darkMode, sizeof(darkMode))) {
            DwmSetWindowAttribute(window, 20, &darkMode, sizeof(darkMode));
        }
    ')
  public static function setDarkMode(enable:Bool) {}

  @:functionCode("
		// simple but effective code
		unsigned long long allocatedRAM = 0;
		GetPhysicallyInstalledSystemMemory(&allocatedRAM);
		return (allocatedRAM / 1024);
	")
  public static function getTotalRam():Float
  {
    return 0;
  }

  #if windows
  @:functionCode('
        HWND window = GetActiveWindow();

        // make window layered
        alpha = SetWindowLong(window, GWL_EXSTYLE, GetWindowLong(window, GWL_EXSTYLE) ^ WS_EX_LAYERED);
        SetLayeredWindowAttributes(window, RGB(red, green, blue), 0, LWA_COLORKEY);
    ')
  #end
  public static function setTransColor(red:Int, green:Int, blue:Int, alpha:Int = 0)
  {
    return alpha;
  }

  // kudos to bing chatgpt thing i hate C++
  #if windows
  @:functionCode('
        HWND hwnd = GetActiveWindow();
        HMENU hmenu = GetSystemMenu(hwnd, FALSE);
        if (enable) {
            EnableMenuItem(hmenu, SC_CLOSE, MF_BYCOMMAND | MF_ENABLED);
        } else {
            EnableMenuItem(hmenu, SC_CLOSE, MF_BYCOMMAND | MF_GRAYED);
        }
    ')
  #end
  public static function setCloseButtonEnabled(enable:Bool)
  {
    return enable;
  }
}
#end
