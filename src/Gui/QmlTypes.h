/***************************************************************************
 *   Copyright (c) 2015 Stefan Tröger <stefantroeger@gmx.net>              *
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


#ifndef GUI_QML_TYPES_H
#define GUI_QML_TYPES_H

#include "PreCompiled.h"
#include <Base/Parameter.h>
#include <QObject>
#include <QGraphicsProxyWidget>
#include <QDeclarativeItem>
#include <QAbstractButton>
#include <QStyle>

namespace Gui {
   
/**
 * @brief Proxy type to add arbitrary qwidgets to the interface
 * 
 * Normally QML components can only be initialized through the qml engine. This forbids to add already
 * created widgets to the interface, as they would need to be wrapped as a qml component. To allow adding
 * already initialized widgets to the scene this QmlProxy can be used. Once added it exposes a proxy 
 * proeprty to which the widget can be assigned from c++. It is then displayed in the Qml scene.
 */
class GuiExport QmlProxy : public QDeclarativeItem {
    
    Q_OBJECT
    Q_PROPERTY(QWidget* proxy READ proxy WRITE setProxy)
  
public:
    QmlProxy(QDeclarativeItem* parent = 0);
    
    QWidget* proxy();
    void setProxy(QWidget*);
    
protected:
    virtual void geometryChanged(const QRectF& newGeometry, const QRectF& oldGeometry);
    
private:
    QGraphicsProxyWidget* m_proxy;
};

class GuiExport QmlButton : public QDeclarativeItem {
  
    Q_OBJECT
    Q_PROPERTY(int margin READ margin WRITE setMargin)
    Q_PROPERTY(QString icon READ icon WRITE setIcon )
    
public:
    QmlButton(QDeclarativeItem* parent = NULL);
    
    bool isHoverd();
    bool isPressed();
    
    int margin() {return m_margin;}
    void setMargin(int m) {m_margin = m;}
    
    QString icon() {return m_icon;}
    void setIcon(QString i) {m_icon = i;}
    
Q_SIGNALS:
    void activated();
    
protected:
    virtual void paint(QPainter*, const QStyleOptionGraphicsItem*, QWidget*); 
    
    virtual void hoverEnterEvent(QGraphicsSceneHoverEvent* event);
    virtual void hoverLeaveEvent(QGraphicsSceneHoverEvent* event);
    virtual void mousePressEvent(QGraphicsSceneMouseEvent* event);
    virtual void mouseReleaseEvent(QGraphicsSceneMouseEvent* event);
    
protected:
    bool pressed, hovered;
    int m_margin;
    QString m_icon;
};

class GuiExport QmlTitleButton : public QmlButton {
    
public:
    enum TitleButtons {
        Min = QStyle::SP_TitleBarMinButton,
        Max = QStyle::SP_TitleBarMaxButton,
        Menu = QStyle::SP_TitleBarMenuButton,
        Close = QStyle::SP_DockWidgetCloseButton,
        Shade = QStyle::SP_TitleBarShadeButton,
        Unshade = QStyle::SP_TitleBarUnshadeButton,
        Help = QStyle::SP_TitleBarContextHelpButton
    };
    
    Q_OBJECT
    Q_ENUMS(TitleButtons)
    Q_PROPERTY(TitleButtons styleIcon READ styleIcon WRITE setStyleIcon)
    
public:    
    QmlTitleButton(QDeclarativeItem* parent = NULL);
    
    virtual void paint(QPainter*, const QStyleOptionGraphicsItem*, QWidget*);
    
    void setStyleIcon(TitleButtons i) {m_styleIcon = i;}
    TitleButtons styleIcon() {return m_styleIcon;}
    
protected:
    TitleButtons m_styleIcon;
};

class GuiExport QmlIcon : public QDeclarativeItem {
  
    Q_OBJECT
    Q_PROPERTY(QIcon icon READ icon WRITE setIcon )
    
public:
    QmlIcon(QDeclarativeItem* parent = NULL);
   
    QIcon icon() {return m_icon;}
    void setIcon(QIcon i) {m_icon = i;}
    
protected:
    virtual void paint(QPainter* p, const QStyleOptionGraphicsItem* op, QWidget* w); 
     
protected:
    QIcon m_icon;
};

class GuiExport QmlMouseCursor : public QDeclarativeItem {
    
    Q_OBJECT
    Q_ENUMS(Qt::CursorShape)
    Q_PROPERTY(Qt::CursorShape cursor READ cursor WRITE setCursor)
    
public:    
    QmlMouseCursor(QDeclarativeItem* parent = NULL);
   
    Qt::CursorShape cursor();
    void setCursor(Qt::CursorShape c);
    
private:
    Qt::CursorShape m_current;
};

class GuiExport QmlSettings : public QObject, public ParameterGrp::ObserverType {

    Q_OBJECT
    Q_PROPERTY(QString tracked READ trackedObject WRITE setTrackedObject)
public:
    
    QmlSettings();
    virtual ~QmlSettings();
    
    Q_INVOKABLE void setBool(QString Name, bool value);
    Q_INVOKABLE bool getBool(QString Name, bool defaultvalue);
    Q_INVOKABLE void setInt(QString Name, int value);
    Q_INVOKABLE int getInt(QString Name, int defaultvalue);
    Q_INVOKABLE void setString(QString Name, QString value);
    Q_INVOKABLE QString getString(QString Name, QString defaultvalue);
    
    QString trackedObject();
    void setTrackedObject(QString s);
    
    virtual void OnChange(Base::Subject< const char* >& rCaller, const char* rcReason);
    
public Q_SLOTS:
    void valueChanged(QString name);
    
protected:
    QString m_tracked;
    ParameterGrp::handle m_grp;
};


static void init_qml_types() {
    qmlRegisterType<QmlProxy>      ("FreeCADLib", 1, 0, "Proxy");
    qmlRegisterType<QmlIcon>       ("FreeCADLib", 1, 0, "Icon");
    qmlRegisterType<QmlButton>     ("FreeCADLib", 1, 0, "Button");
    qmlRegisterType<QmlTitleButton>("FreeCADLib", 1, 0, "TitleButton");
    qmlRegisterType<QmlMouseCursor>("FreeCADLib", 1, 0, "MouseCursor");
    qmlRegisterType<QmlSettings>   ("FreeCADLib", 1, 0, "Settings");
};

} // namespace Gui

#endif // GUI_MAINWINDOW_H
