import Cocoa

let bdwAPI = bitsdojo_window_api().pointee;
let bdwPrivateAPI = bdwAPI.privateAPI.pointee;
let bdwPublicAPI = bdwAPI.publicAPI.pointee;

public let BDW_CUSTOM_FRAME: UInt = 0x1
public let BDW_HIDE_ON_STARTUP: UInt = 0x2

open class BitsdojoWindow: NSWindow {
  
  override public var canBecomeKey: Bool {
    get {
      return true
    }
  }
  open func bitsdojo_window_configure() -> UInt {
    return 0
  }
  override init(
    contentRect: NSRect, styleMask style: NSWindow.StyleMask,
    backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool
  ) {
    super.init(contentRect: contentRect, styleMask: style, backing: backingStoreType, defer: flag)

  }
  override public func order(_ place: NSWindow.OrderingMode, relativeTo otherWin: Int) {
    if (!bdwPrivateAPI.appWindowIsSet())
    {
        bdwPrivateAPI.setAppWindow(self);
    }
    let flags = self.bitsdojo_window_configure()

    let hideOnStartup:Bool = ((flags & BDW_HIDE_ON_STARTUP) != 0);
    let hasCustomFrame:Bool = ((flags & BDW_CUSTOM_FRAME) != 0);

    var localStyle = self.styleMask;
    if hasCustomFrame {
        localStyle.insert(.fullSizeContentView)
        self.styleMask = localStyle;
        self.titlebarAppearsTransparent = true
        self.titleVisibility = .hidden
        self.isOpaque = false
        self.isMovable = true
    }
    super.order(place, relativeTo: otherWin)
    let windowCanBeShown: Bool = bdwPrivateAPI.windowCanBeShown();
    if (!(windowCanBeShown) && hideOnStartup && self.isVisible) {
        self.setIsVisible(false)
    }
  }
}
