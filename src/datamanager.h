#ifndef DATAMANAGER_H
#define DATAMANAGER_H

#include <QJSEngine>
#include <QObject>
#include <QQmlEngine>

#include <BCONNetwork/bconnetwork.h>

class DataManager : public QObject, public DataSubscriber
{
    Q_OBJECT
public:
    Q_PROPERTY( QString playerId MEMBER sCurrentPlayerId NOTIFY playerIdChanged() )
    Q_PROPERTY( QString firstName MEMBER sCurrentPlayerFirstName NOTIFY firstNameChanged() )
    Q_PROPERTY( QString lastName MEMBER sCurrentPlayerLastName NOTIFY lastNameChanged() )
    Q_PROPERTY( QString screenName MEMBER sCurrentPlayerScreenName NOTIFY screenNameChanged() )
    Q_PROPERTY( int tokens MEMBER iCurrentPlayerTokens NOTIFY tokensChanged() )
    Q_PROPERTY( int tickets MEMBER iCurrentPlayerTickets NOTIFY ticketsChanged() )
    Q_PROPERTY( QVariantList stats MEMBER CurrentPlayerStats NOTIFY statsChanged() )
    Q_PROPERTY( int statusCode MEMBER iLastStatusCode NOTIFY statusCodeChanged() )

    static DataManager * instance();
    static DataManager * qmlAttachedProperties( QObject * pObject );

signals:
    void cardInserted();

    void playerIdChanged();
    void firstNameChanged();
    void lastNameChanged();
    void screenNameChanged();
    void tokensChanged();
    void ticketsChanged();
    void statsChanged();

    void statusCodeChanged();

public slots:
    void handleData( const DataPoint & Data ) override;

    void createPlayer( const QString & sFirstName, const QString & sLastName, const QString & sScreenName );
    void addTokens( const int & iTokens );
    void updateScreenName( const QString & sScreenName );

private slots:
    void on_nfcManagerCardInserted();
    void on_nfcManagerCardRead( const QString & sId );

private:
    QString sCurrentPlayerId;
    QString sCurrentPlayerFirstName;
    QString sCurrentPlayerLastName;
    QString sCurrentPlayerScreenName;
    int iCurrentPlayerTokens;
    int iCurrentPlayerTickets;
    QVariantList CurrentPlayerStats;

    int iLastStatusCode;

    explicit DataManager( QObject * pParent = nullptr );
};

QObject * datamanager_singletontype_provider( QQmlEngine * pEngine, QJSEngine * pScriptEngine );

QML_DECLARE_TYPEINFO( DataManager, QML_HAS_ATTACHED_PROPERTIES );

#endif // DATAMANAGER_H
