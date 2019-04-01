#include <QCoreApplication>
#include <QDebug>
#include <QQmlApplicationEngine>
#include <QRegularExpression>

#include "datamanager.h"

extern BCONNetwork *pBackend;
extern QQmlApplicationEngine *pEngine;
/*--------------------------------------------------------------------------------------------------------------------*/

static DataManager *pInstance = nullptr;
/*--------------------------------------------------------------------------------------------------------------------*/

DataManager::DataManager( QObject * pParent ) : QObject( pParent )
{
    sCurrentPlayerId = "";
    sCurrentPlayerFirstName = "";
    sCurrentPlayerLastName = "";
    sCurrentPlayerScreenName = "";
    iCurrentPlayerTokens = -1;
    iCurrentPlayerTickets = -1;
    iLastStatusCode = 0;

    /* Wire up to the NFCManager signals. */
    connect( NFCManager::instance(), SIGNAL( cardInserted() ), this, SLOT( on_nfcManagerCardInserted() ) );
    connect( NFCManager::instance(), SIGNAL( cardRead( const QString & ) ), this, SLOT( on_nfcManagerCardRead( const QString & ) ) );

    /* Subscribe to player information. */
    DataStore::subscribe( "playerId",    this );
    DataStore::subscribe( "firstName",   this );
    DataStore::subscribe( "lastName",    this );
    DataStore::subscribe( "screenName",  this );
    DataStore::subscribe( "tokens",      this );
    DataStore::subscribe( "tickets",     this );
    DataStore::subscribe( "gameStats.$", this );

    /* Subscribe to the HTTP status code for errors. */
    DataStore::subscribe( "statusCode", this );
}
/*--------------------------------------------------------------------------------------------------------------------*/

DataManager * DataManager::instance()
{
    if ( nullptr == pInstance )
    {
        pInstance = new DataManager();
    }

    return pInstance;
}
/*--------------------------------------------------------------------------------------------------------------------*/

void DataManager::handleData( const DataPoint & Data )
{
    QRegularExpression Regex;
    QRegularExpressionMatch Matches;

    /* Player data. */
    Regex.setPattern( "^firstName$" );
    Matches = Regex.match( Data.sTag );
    if ( Matches.hasMatch() )
    {
        sCurrentPlayerFirstName = Data.Value.toString();
        emit firstNameChanged();
        return;
    }

    Regex.setPattern( "^lastName$" );
    Matches = Regex.match( Data.sTag );
    if ( Matches.hasMatch() )
    {
        sCurrentPlayerLastName = Data.Value.toString();
        emit lastNameChanged();
        return;
    }

    Regex.setPattern( "^screenName$" );
    Matches = Regex.match( Data.sTag );
    if ( Matches.hasMatch() )
    {
        sCurrentPlayerScreenName = Data.Value.toString();
        emit screenNameChanged();
        return;
    }

    Regex.setPattern( "^tokens$" );
    Matches = Regex.match( Data.sTag );
    if ( Matches.hasMatch() )
    {
        iCurrentPlayerTokens = Data.Value.toInt();
        emit tokensChanged();
        return;
    }

    Regex.setPattern( "^tickets$" );
    Matches = Regex.match( Data.sTag );
    if ( Matches.hasMatch() )
    {
        iCurrentPlayerTickets = Data.Value.toInt();
        emit ticketsChanged();
        return;
    }

    Regex.setPattern( "^gameStats\\.\\$$" );
    Matches = Regex.match( Data.sTag );
    if ( Matches.hasMatch() )
    {
        CurrentPlayerStats.clear();

        /* Build the list of published stats. */
        for ( int i = 0; i < DataStore::getDataPoint( "gameStats.length" ).Value.toInt(); i++ )
        {
            QString sGameName = DataStore::getDataPoint( "games."
                                                         + DataStore::getDataPoint( "gameStats."
                                                                                    + QString::number( i )
                                                                                    + ".gameId" ).Value.toString()
                                                         + ".name" ).Value.toString();

            QVariantList Stat{
                sGameName,
                DataStore::getDataPoint( "gameStats." + QString::number( i ) + ".gamesPlayed" ).Value.toInt(),
                DataStore::getDataPoint( "gameStats." + QString::number( i ) + ".highScore" ).Value.toInt(),
                DataStore::getDataPoint( "gameStats." + QString::number( i ) + ".ticketsEarned" ).Value.toInt()
            };

            /* Add a subscription for the game name for later substitution. */
            DataStore::subscribe( "games." + Stat.first().toString() + ".name", this );

            CurrentPlayerStats << QVariant::fromValue( Stat );
        }

        emit statsChanged();
        return;
    }

    /* Error codes. */
    Regex.setPattern( "^statusCode$" );
    Matches = Regex.match( Data.sTag );
    if ( Matches.hasMatch() )
    {
        iLastStatusCode = Data.Value.toInt();
        emit statusCodeChanged();
        return;
    }
}
/*--------------------------------------------------------------------------------------------------------------------*/

void DataManager::on_nfcManagerCardInserted()
{
    /* Pass the signal through so QML can pick it up. */
    emit cardInserted();
}
/*--------------------------------------------------------------------------------------------------------------------*/

void DataManager::on_nfcManagerCardRead( const QString & sId )
{
    sCurrentPlayerId = sId;
    emit playerIdChanged();

    /* Fetch the player information from the backend. */
    pBackend->getPlayer( sId );
}
/*--------------------------------------------------------------------------------------------------------------------*/

void DataManager::createPlayer( const QString & sFirstName, const QString & sLastName, const QString & sScreenName )
{
    pBackend->createPlayer( sCurrentPlayerId, sFirstName, sLastName, sScreenName );
}
/*--------------------------------------------------------------------------------------------------------------------*/

QObject * datamanager_singletontype_provider( QQmlEngine * pEngine, QJSEngine * pScriptEngine )
{
     Q_UNUSED( pEngine )
     Q_UNUSED( pScriptEngine )

     return DataManager::instance();
}
/*--------------------------------------------------------------------------------------------------------------------*/
