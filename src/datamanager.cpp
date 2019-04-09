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
    DataStore::subscribe( "prizes.$",    this );

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
            /* Retrieve the game name. */
            QString sGameName = "";
            for ( int j = 0; j < DataStore::getDataPoint( "games.length" ).Value.toInt(); j++ )
            {
                if ( 0 == QString::compare(
                         DataStore::getDataPoint( "gameStats." + QString::number( i ) + ".gameId" ).Value.toString(),
                         DataStore::getDataPoint( "games." + QString::number( j ) + "._id" ).Value.toString() ) )
                {
                    sGameName = DataStore::getDataPoint( "games." + QString::number( j ) + ".name" ).Value.toString();
                    break;
                }
            }

            QVariantList Stat{
                sGameName,
                DataStore::getDataPoint( "gameStats." + QString::number( i ) + ".gamesPlayed" ).Value.toInt(),
                DataStore::getDataPoint( "gameStats." + QString::number( i ) + ".highScore" ).Value.toInt(),
                DataStore::getDataPoint( "gameStats." + QString::number( i ) + ".ticketsEarned" ).Value.toInt()
            };

            CurrentPlayerStats << QVariant::fromValue( Stat );
        }

        emit statsChanged();
        return;
    }

    Regex.setPattern( "^prizes\\.\\$$" );
    Matches = Regex.match( Data.sTag );
    if ( Matches.hasMatch() )
    {
        /* Clean the list if necessary. */
        if ( !PrizeList.empty() )
        {
            qDeleteAll( PrizeList.begin(), PrizeList.end() );
            PrizeList.clear();
        }

        /* Populate the list of prizes. */
        for ( int i = 0; i < DataStore::getDataPoint( "prizes.length" ).Value.toInt(); i++ )
        {
            PrizeList.append( new Prize( DataStore::getDataPoint(
                                             "prizes." + QString::number( i ) + ".name" ).Value.toString(),
                                         DataStore::getDataPoint(
                                             "prizes." + QString::number( i ) + ".description" ).Value.toString(),
                                         DataStore::getDataPoint(
                                             "prizes." + QString::number( i ) + ".ticketCost" ).Value.toInt(),
                                         DataStore::getDataPoint(
                                             "prizes." + QString::number( i ) + ".availableQuantity" ).Value.toInt(),
                                         DataStore::getDataPoint(
                                             "prizes." + QString::number( i ) + ".imageData" ).Value.toString() ) );
        }

        emit prizeListChanged();
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

void DataManager::addTokens( const int & iTokens )
{
    pBackend->updatePlayerTokens( sCurrentPlayerId, iCurrentPlayerTokens + iTokens );
}
/*--------------------------------------------------------------------------------------------------------------------*/

void DataManager::updateScreenName( const QString & sScreenName )
{
    pBackend->updatePlayerScreenName( sCurrentPlayerId, sScreenName );
}
/*--------------------------------------------------------------------------------------------------------------------*/

void DataManager::redeemPrize( const int & iModelIndex )
{
    if ( 0 <= iModelIndex )
    {
        pBackend->redeemPrize( DataStore::getDataPoint( "prizes." + QString::number( iModelIndex ) + "._id" )
                               .Value.toString(), sCurrentPlayerId );

        /* Refresh the prizes and player information. */
        pBackend->getAllPrizes();
        pBackend->getPlayer( sCurrentPlayerId );
    }
}
/*--------------------------------------------------------------------------------------------------------------------*/

QObject * datamanager_singletontype_provider( QQmlEngine * pEngine, QJSEngine * pScriptEngine )
{
     Q_UNUSED( pEngine )
     Q_UNUSED( pScriptEngine )

     return DataManager::instance();
}
/*--------------------------------------------------------------------------------------------------------------------*/
