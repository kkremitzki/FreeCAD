/***************************************************************************
 *   Copyright (c) 2014 StefanTroeger <stefantroeger@gmx.net>              *
 *                                                                         *
 *   This file is part of the FreeCAD CAx development system.              *
 *                                                                         *
 *   This library is free software; you can redistribute it and/or         *
 *   modify it under the terms of the GNU Library General Public           *
 *   License as published by the Free Software Foundation; either          *
 *   version 2 of the License, or (at your option) any later version.      *
 *                                                                         *
 *   This library  is distributed in the hope that it will be useful,      *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
 *   GNU Library General Public License for more details.                  *
 *                                                                         *
 *   You should have received a copy of the GNU Library General Public     *
 *   License along with this library; see the file COPYING.LIB. If not,    *
 *   write to the Free Software Foundation, Inc., 59 Temple Place,         *
 *   Suite 330, Boston, MA  02111-1307, USA                                *
 *                                                                         *
 ***************************************************************************/

import QtQuick 1.1
import FreeCADLib 1.0

Item {
    
    id: resizeitem 
    
    property bool fixedWidth:  false
    property bool fixedHeight: false
    
    property Item interfaceitem;
         
    MouseCursor {
        id: cursorItem
    }
       
     //this is the top drag area
    MouseArea {
        id: topResizeArea
        anchors.left: parent.left
        anchors.right: parent.right
        height: interfaceitem.dragframe
        
        property bool draggable: true;

        enabled: !fixedHeight
        
        hoverEnabled: true
        onEntered: {
            draggable = interfaceitem.canDrag('top');
            if(draggable)
                cursorItem.cursor = Qt.SizeVerCursor
        }
        onExited:  {
            if(!drag.active) cursorItem.cursor = Qt.ArrowCursor
        }
        
        onPressed: interfaceitem.resizeDragItem.y = interfaceitem.y;
        
        drag.target: interfaceitem.resizeDragItem
        drag.axis: Drag.YAxis
        drag.minimumY: 0
        drag.maximumY: interfaceitem.y + interfaceitem.height - interfaceitem.totalMinHeight
        
        drag.onActiveChanged: {
            if(drag.active && draggable) {
                var y_ = interfaceitem.y + interfaceitem.height;
                interfaceitem.setupResize(0, y_, 'bottom', 'top');
            }
            else if(draggable) {
                interfaceitem.clearResize('bottom', 'top');
                cursorItem.cursor = Qt.ArrowCursor
            }
            
        }
    }

    //this is the bottom drag area
    MouseArea {
        id: bottomResizeArea
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        height: dragframe
                
        property bool draggable: true;

        enabled: !fixedHeight
        
        hoverEnabled: true
        onEntered: {
            draggable = interfaceitem.canDrag('bottom');
            if(draggable)
                cursorItem.cursor = Qt.SizeVerCursor
        }
        onExited:  {
            if(!drag.active) cursorItem.cursor = Qt.ArrowCursor
        }
                
        onPressed: interfaceitem.resizeDragItem.y = interfaceitem.y + interfaceitem.height;
                
        drag.target: interfaceitem.resizeDragItem
        drag.axis: Drag.YAxis
        drag.minimumY: interfaceitem.y + interfaceitem.totalMinHeight;
                
        drag.onActiveChanged: {
            if(drag.active && draggable) {
                drag.maximumY = interfaceitem.parent.height;
                var y_ = interfaceitem.y;
                interfaceitem.setupResize(0, y_, 'top', 'bottom');
            }
            else if(draggable) {
                interfaceitem.clearResize('top', 'bottom');
                cursorItem.cursor = Qt.ArrowCursor
            }
        }
    }
    
    //this is the left drag area
    MouseArea {
        id: leftResizeArea
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: dragframe
                
        property bool draggable: true;
        
        enabled: !fixedWidth

        hoverEnabled: true
        onEntered: {
            draggable = interfaceitem.canDrag('left');
            if(draggable)
                cursorItem.cursor = Qt.SizeHorCursor
        }
        onExited:  {
            if(!drag.active) cursorItem.cursor = Qt.ArrowCursor
        }
                
        onPressed: interfaceitem.resizeDragItem.x = interfaceitem.x;
                
        drag.target: interfaceitem.resizeDragItem
        drag.axis: Drag.XAxis
        drag.minimumX: 0
        drag.maximumX: interfaceitem.x + interfaceitem.width - interfaceitem.minWidth
                
        drag.onActiveChanged: {
            if(drag.active && draggable) {
                var x = interfaceitem.x + interfaceitem.width;
                interfaceitem.setupResize(x, 0, 'right', 'left');
            }
            else if(draggable) {
                interfaceitem.clearResize('right', 'left');
                cursorItem.cursor = Qt.ArrowCursor
            }
        }
    }
    
    //this is the right drag area
    MouseArea {
        id: rightResizeArea
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        width: dragframe
                
        property bool draggable: true;

        enabled: !fixedWidth
        
        hoverEnabled: true
        onEntered: {
            draggable = interfaceitem.canDrag('right');
            if(draggable)
                cursorItem.cursor = Qt.SizeHorCursor
        }
        onExited:  {
            if(!drag.active) cursorItem.cursor = Qt.ArrowCursor
        }
                
        onPressed: interfaceitem.resizeDragItem.x = interfaceitem.x + interfaceitem.width;
                
        drag.target: interfaceitem.resizeDragItem
        drag.axis: Drag.XAxis
        drag.minimumX: interfaceitem.x + interfaceitem.minWidth;
                
        drag.onActiveChanged: {
            if(drag.active && draggable) {
                drag.maximumX = interfaceitem.parent.width; //parent is not defined on creation
                var x = interfaceitem.x;
                interfaceitem.setupResize(x, 0, 'left', 'right');
            }
            else if(draggable) {
                interfaceitem.clearResize('left', 'right');
                cursorItem.cursor = Qt.ArrowCursor
            }
        }
    }
    
    //go on with the corners
    //**********************
    
    
    //this is the top right drag area
    MouseArea {
        id: toprightResizeArea
        anchors.right: parent.right
        anchors.top: parent.top
        width:  dragframe
        height: dragframe
                
        property bool x_draggable: true;
        property bool y_draggable: true;

        enabled: !fixedWidth || !fixedHeight
        
        hoverEnabled: true
        onEntered: {
            x_draggable = interfaceitem.canDrag('right') && !fixedWidth;
            y_draggable = interfaceitem.canDrag('top') && !fixedHeight;
            if(x_draggable || y_draggable)
                cursorItem.cursor = Qt.SizeBDiagCursor
        }
        onExited:  {
            if(!drag.active) cursorItem.cursor = Qt.ArrowCursor
        }
                
        onPressed: {
            interfaceitem.resizeDragItem.x = interfaceitem.x + interfaceitem.width;
            interfaceitem.resizeDragItem.y = interfaceitem.y;
        }
                
        drag.target: interfaceitem.resizeDragItem
        drag.minimumX: interfaceitem.x + interfaceitem.minWidth;
        drag.minimumY: 0
        drag.maximumY: interfaceitem.y + interfaceitem.height - interfaceitem.totalMinHeight
                 
        drag.onActiveChanged: {
            if(drag.active && (x_draggable || y_draggable)) {
                drag.maximumX = interfaceitem.parent.width; //parent is not defined on creation
                var y = interfaceitem.y + interfaceitem.height;
                if(x_draggable)
                    interfaceitem.setupResize(interfaceitem.x, y, 'left', 'right');
                if(y_draggable)
                    interfaceitem.setupResize(interfaceitem.x, y, 'bottom', 'top')
            }
            else if(x_draggable || y_draggable) {
                if(x_draggable)
                    interfaceitem.clearResize('left', 'right');
                if(y_draggable)
                    interfaceitem.clearResize('bottom', 'top');
                
                cursorItem.cursor = Qt.ArrowCursor
            }
        }
    }
    
    //this is the bottom left drag area
    MouseArea {
        id: bottomleftResizeArea
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        width:  dragframe
        height: dragframe
                
        property bool x_draggable: true;
        property bool y_draggable: true;

        enabled: !fixedWidth || !fixedHeight
        
        hoverEnabled: true
        onEntered: {
            x_draggable = interfaceitem.canDrag('left') && !fixedWidth;
            y_draggable = interfaceitem.canDrag('bottom') && !fixedHeight;
            if(x_draggable || y_draggable)
                cursorItem.cursor = Qt.SizeBDiagCursor
        }
        onExited:  {
            if(!drag.active) cursorItem.cursor = Qt.ArrowCursor
        }
                
        onPressed: {
            interfaceitem.resizeDragItem.x = interfaceitem.x;
            interfaceitem.resizeDragItem.y = interfaceitem.y + interfaceitem.height;
        }
                
        drag.target: interfaceitem.resizeDragItem
        drag.minimumX: 0;
        drag.maximumX: interfaceitem.x + interfaceitem.width - interfaceitem.minWidth;
        drag.minimumY: interfaceitem.y + interfaceitem.totalMinHeight
                 
        drag.onActiveChanged: {
            if(drag.active && (x_draggable || y_draggable)) {
                drag.maximumY = interfaceitem.parent.height; //parent is not defined on creation
                var x = interfaceitem.x + interfaceitem.width;
                if(x_draggable)
                    interfaceitem.setupResize(x, interfaceitem.y, 'right', 'left');
                if(y_draggable)
                    interfaceitem.setupResize(x, interfaceitem.y, 'top', 'bottom')
            }
            else if(x_draggable || y_draggable) {
                if(x_draggable)
                    interfaceitem.clearResize('right', 'left');
                if(y_draggable)
                    interfaceitem.clearResize('top', 'bottom');
                
                cursorItem.cursor = Qt.ArrowCursor
            }
        }
    }
    
    //this is the top left drag area
    MouseArea {
        id: topleftResizeArea
        anchors.left: parent.left
        anchors.top: parent.top
        width:  dragframe
        height: dragframe
                
        property bool x_draggable: true;
        property bool y_draggable: true;

        enabled: !fixedWidth || !fixedHeight
        
        hoverEnabled: true
        onEntered: {
            x_draggable = interfaceitem.canDrag('left') && !fixedWidth;
            y_draggable = interfaceitem.canDrag('top') && !fixedHeight;
            if(x_draggable || y_draggable)
                cursorItem.cursor = Qt.SizeFDiagCursor
        }
        onExited:  {
            if(!drag.active) cursorItem.cursor = Qt.ArrowCursor
        }
                
        onPressed: {
            interfaceitem.resizeDragItem.x = interfaceitem.x;
            interfaceitem.resizeDragItem.y = interfaceitem.y;
        }
                
        drag.target: interfaceitem.resizeDragItem
        drag.minimumX: 0;
        drag.maximumX: interfaceitem.x + interfaceitem.width - interfaceitem.minWidth;
        drag.minimumY: 0;
        drag.maximumY: interfaceitem.y + interfaceitem.height - interfaceitem.totalMinHeight;
                 
        drag.onActiveChanged: {
            if(drag.active && (x_draggable || y_draggable)) {
                var x = interfaceitem.x + interfaceitem.width;
                var y = interfaceitem.y + interfaceitem.height;
                if(x_draggable)
                    interfaceitem.setupResize(x, y, 'right', 'left');
                if(y_draggable)
                    interfaceitem.setupResize(x, y, 'bottom', 'top')
            }
            else if(x_draggable || y_draggable) {
                if(x_draggable)
                    interfaceitem.clearResize('right', 'left');
                if(y_draggable)
                    interfaceitem.clearResize('bottom', 'left');
                
                cursorItem.cursor = Qt.ArrowCursor
            }
        }
    }
    
    //this is the bottom right drag area
    MouseArea {
        id: bottomrightResizeArea
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        width:  dragframe
        height: dragframe
                
        property bool x_draggable: true;
        property bool y_draggable: true;

        enabled: !fixedWidth || !fixedHeight
        
        hoverEnabled: true
        onEntered: {
            x_draggable = interfaceitem.canDrag('right') && !fixedWidth;
            y_draggable = interfaceitem.canDrag('bottom') && !fixedHeight;
            if(x_draggable || y_draggable)
                cursorItem.cursor = Qt.SizeFDiagCursor
        }
        onExited:  {
            if(!drag.active) cursorItem.cursor = Qt.ArrowCursor
        }
                
        onPressed: {
            interfaceitem.resizeDragItem.x = interfaceitem.x + interfaceitem.width;
            interfaceitem.resizeDragItem.y = interfaceitem.y + interfaceitem.height;
        }
                
        drag.target: interfaceitem.resizeDragItem
        drag.minimumX: interfaceitem.x + interfaceitem.minWidth;
        drag.minimumY: interfaceitem.y + interfaceitem.totalMinHeight;
                  
        drag.onActiveChanged: {
            if(drag.active && (x_draggable || y_draggable)) {
                drag.maximumY = interfaceitem.parent.height;
                drag.maximumX = interfaceitem.parent.width;
                var y = interfaceitem.y;
                if(x_draggable)
                    interfaceitem.setupResize(interfaceitem.x, y, 'left', 'right');
                if(y_draggable)
                    interfaceitem.setupResize(interfaceitem.x, y, 'top', 'bottom')
            }
            else if(x_draggable || y_draggable) {
                if(x_draggable)
                    interfaceitem.clearResize('left', 'right');
                if(y_draggable)
                    interfaceitem.clearResize('top', 'bottom');
                cursorItem.cursor = Qt.ArrowCursor
            }
        }
    }
}