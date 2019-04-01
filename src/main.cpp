#include <QDebug>
#include <QFont>
#include <QFontDatabase>
#include <QGuiApplication>
#include <QQmlApplicationEngine>

#include <BCONNetwork/bconnetwork.h>

#include "datamanager.h"
/*--------------------------------------------------------------------------------------------------------------------*/

extern BCONNetwork *pBackend;
extern QQmlApplicationEngine *pEngine;
/*--------------------------------------------------------------------------------------------------------------------*/

BCONNetwork *pBackend = nullptr;
QQmlApplicationEngine *pEngine = nullptr;
/*--------------------------------------------------------------------------------------------------------------------*/

int main( int argc, char * argv[] )
{
    /* Bring in the Virtual Keybaord. */
    qputenv( "QT_IM_MODULE", QByteArray( "qtvirtualkeyboard" ) );

    QCoreApplication::setAttribute( Qt::AA_EnableHighDpiScaling );

    QGuiApplication App( argc, argv );

    /* Set the custom font. */
    ( void )QFontDatabase::addApplicationFont( ":/fonts/San_Francisco-Bold.ttf" );
    ( void )QFontDatabase::addApplicationFont( ":/fonts/San_Francisco-Regular.ttf" );
    QFont Font( "SFNS Display" );
    QGuiApplication::setFont( Font );

    /* Register the NFC Manager in the QML context. */
    qmlRegisterSingletonType<DataManager>( "com.bcon.datamanager", 1, 0, "DataManager", datamanager_singletontype_provider );
    QQmlEngine::setObjectOwnership( qobject_cast<QObject *>( DataManager::instance() ), QQmlEngine::CppOwnership );
    DataManager::instance()->setParent( &App );

    /* Create the QML context. */
    QQmlApplicationEngine Engine;
    Engine.load( QUrl( QStringLiteral( "qrc:/main.qml" ) ) );
    if ( !Engine.rootObjects().isEmpty() )
    {
        pEngine = &Engine;
    }
    else
    {
        return -1;
    }

    /* Initialize the BCON network. */
    pBackend = new BCONNetwork();

    /* Request all games now to keep them in the data store for later reference. */
    pBackend->getAllGames();

    return App.exec();
}
/*--------------------------------------------------------------------------------------------------------------------*/
