# -*- coding: utf-8 -*-
# AddonManager gui init module
# (c) 2017 Kurt Kremitzki
# License LGPL

import FreeCAD, FreeCADGui

class AddonManagerCmd:
        def GetResources(self):
                return {"MenuText": "&Addon manager",
                        "ToolTip": "Manage FreeCAD workbenches and macros",
                        "Pixmap"  : "addon-manager"}

        def Initialize(self):
            pass

        def IsActive(self):
            return True

        def Activated(self):
            import AddonManager
            dialog = AddonManager.AddonsInstaller()
            dialog.exec_()


FreeCADGui.addCommand('ActivateAddonManager', AddonManagerCmd())
