# ***************************************************************************
# *                                                                         *
# *   Copyright (c) 2017 - Kurt Kremitzki <kkremitzki@gmail.com>            *
# *                                                                         *
# *   This program is free software; you can redistribute it and/or modify  *
# *   it under the terms of the GNU Lesser General Public License (LGPL)    *
# *   as published by the Free Software Foundation; either version 2 of     *
# *   the License, or (at your option) any later version.                   *
# *   for detail see the LICENCE text file.                                 *
# *                                                                         *
# *   This program is distributed in the hope that it will be useful,       *
# *   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
# *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
# *   GNU Library General Public License for more details.                  *
# *                                                                         *
# *   You should have received a copy of the GNU Library General Public     *
# *   License along with this program; if not, write to the Free Software   *
# *   Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  *
# *   USA                                                                   *
# *                                                                         *
# ***************************************************************************


import FreeCAD

from AttachmentEditor.Commands import editAttachment

if FreeCAD.GuiUp:
    import FreeCADGui
    from PySide import QtCore, QtGui
    from DraftTools import translate
    from PySide.QtCore import QT_TRANSLATE_NOOP
else:
    def translate(ctxt,txt):
        return txt
    def QT_TRANSLATE_NOOP(ctxt,txt):
        return txt

class CommandPoint:
    def GetResources(self):
        return { 'MenuText': QT_TRANSLATE_NOOP('PartDesign', 'Create a datum point'),
                 'ToolTip': QT_TRANSLATE_NOOP('PartDesign', 'Create a new datum point'),
                 'Pixmap': 'PartDesign_Point'
               }

    def IsActive(self):
        return not FreeCAD.ActiveDocument is None

    def Activated(self):
        # Need to check for body existence first
        self.body = FreeCADGui.activeView().getActiveObject("pdbody")

        if self.body is None:
            bodies = FreeCAD.ActiveDocument.findObjects('PartDesign::Body')
            if len(bodies) == 0:
                self.body = FreeCAD.ActiveDocument.addObject("PartDesign::Body", "Body")
            elif len(bodies) == 1:
                self.body = bodies[0]
            else:
                # Need to show warning to activate a body
                return
            FreeCADGui.activeView().setActiveObject("pdbody", self.body)

        # Account for selection having been made
        sel = FreeCADGui.Selection.getSelection()
        take_selection = bool(sel)
        if len(sel) == 1:
            if sel[0].TypeId == 'PartDesign::Point':
                self.point = sel[0]
                sel = []
                take_selection = bool(sel)
            elif sel[0].TypeId == 'PartDesign::Body':
                self.point = FreeCAD.ActiveDocument.addObject("PartDesign::Point", "DatumPoint")
                self.body.addObject(self.point)
                sel = []
                take_selection = bool(sel)
            else:
                self.point = FreeCAD.ActiveDocument.addObject("PartDesign::Point", "DatumPoint")
                self.body.addObject(self.point)
        else:
            self.point = FreeCAD.ActiveDocument.addObject("PartDesign::Point", "DatumPoint")
            self.body.addObject(self.point)
            FreeCAD.ActiveDocument.recompute()

        # Should be handled in another way, no cleanup
        FreeCADGui.ActiveDocument.getObject(self.body.Origin.Name).Visibility = True

        try:
            editAttachment(self.point, take_selection)
        except Exception as err:
            from PySide import QtGui
            mb = QtGui.QMessageBox()
            mb.setIcon(mb.Icon.Warning)
            mb.setText(str(err))
            mb.setWindowTitle("Error")
            mb.exec_()

class CommandLine:
    def GetResources(self):
        return { 'MenuText': QT_TRANSLATE_NOOP('PartDesign', 'Create a datum line'),
                 'ToolTip': QT_TRANSLATE_NOOP('PartDesign', 'Create a new datum line'),
                 'Pixmap': 'PartDesign_Line'
               }

    def IsActive(self):
        return not FreeCAD.ActiveDocument is None

    def Activated(self):
        # Need to check for body existence first
        self.body = FreeCADGui.activeView().getActiveObject("pdbody")

        if self.body is None:
            bodies = FreeCAD.ActiveDocument.findObjects('PartDesign::Body')
            if len(bodies) == 0:
                self.body = FreeCAD.ActiveDocument.addObject("PartDesign::Body", "Body")
            elif len(bodies) == 1:
                self.body = bodies[0]
            else:
                # Need to show warning to activate a body
                return
            FreeCADGui.activeView().setActiveObject("pdbody", self.body)

        # Account for selection having been made
        sel = FreeCADGui.Selection.getSelection()
        take_selection = bool(sel)
        if len(sel) == 1:
            if sel[0].TypeId == 'PartDesign::Line':
                self.line = sel[0]
                sel = []
                take_selection = bool(sel)
            elif sel[0].TypeId == 'PartDesign::Body':
                self.line = FreeCAD.ActiveDocument.addObject("PartDesign::Line", "DatumLine")
                self.body.addObject(self.line)
                sel = []
                take_selection = bool(sel)
            else:
                self.line = FreeCAD.ActiveDocument.addObject("PartDesign::Line", "DatumLine")
                self.body.addObject(self.line)
        else:
            self.line = FreeCAD.ActiveDocument.addObject("PartDesign::Line", "DatumLine")
            self.body.addObject(self.line)
            FreeCAD.ActiveDocument.recompute()

        # Should be handled in another way, no cleanup
        FreeCADGui.ActiveDocument.getObject(self.body.Origin.Name).Visibility = True

        try:
            editAttachment(self.line, take_selection)
        except Exception as err:
            from PySide import QtGui
            mb = QtGui.QMessageBox()
            mb.setIcon(mb.Icon.Warning)
            mb.setText(str(err))
            mb.setWindowTitle("Error")
            mb.exec_()

class CommandPlane:
    def GetResources(self):
        return { 'MenuText': QT_TRANSLATE_NOOP('PartDesign', 'Create a datum plane'),
                 'ToolTip': QT_TRANSLATE_NOOP('PartDesign', 'Create a new datum plane'),
                 'Pixmap': 'PartDesign_Plane'
               }

    def IsActive(self):
        return not FreeCAD.ActiveDocument is None

    def Activated(self):
        # Need to check for body existence first
        self.body = FreeCADGui.activeView().getActiveObject("pdbody")

        if self.body is None:
            bodies = FreeCAD.ActiveDocument.findObjects('PartDesign::Body')
            if len(bodies) == 0:
                self.body = FreeCAD.ActiveDocument.addObject("PartDesign::Body", "Body")
            elif len(bodies) == 1:
                self.body = bodies[0]
            else:
                # Need to show warning to activate a body
                return
            FreeCADGui.activeView().setActiveObject("pdbody", self.body)

        # Account for selection having been made
        sel = FreeCADGui.Selection.getSelection()
        take_selection = bool(sel)
        if len(sel) == 1:
            if sel[0].TypeId == 'PartDesign::Plane':
                self.plane = sel[0]
                sel = []
                take_selection = bool(sel)
            elif sel[0].TypeId == 'PartDesign::Body':
                self.plane = FreeCAD.ActiveDocument.addObject("PartDesign::Plane", "DatumPlane")
                self.body.addObject(self.plane)
                sel = []
                take_selection = bool(sel)
            else:
                self.plane = FreeCAD.ActiveDocument.addObject("PartDesign::Plane", "DatumPlane")
                self.body.addObject(self.plane)
        else:
            self.plane = FreeCAD.ActiveDocument.addObject("PartDesign::Plane", "DatumPlane")
            self.body.addObject(self.plane)
            FreeCAD.ActiveDocument.recompute()

        # Should be handled in another way, no cleanup
        FreeCADGui.ActiveDocument.getObject(self.body.Origin.Name).Visibility = True

        try:
            editAttachment(self.plane, take_selection)
        except Exception as err:
            from PySide import QtGui
            mb = QtGui.QMessageBox()
            mb.setIcon(mb.Icon.Warning)
            mb.setText(str(err))
            mb.setWindowTitle("Error")
            mb.exec_()

