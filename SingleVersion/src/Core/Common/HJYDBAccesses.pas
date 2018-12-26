unit HJYDBAccesses;

interface

uses Classes, DBClient, HJYStoreProcParams;

type
  IHJYDBAccess = interface
    ['{B8296D48-39DB-4BBD-8CF4-291BEEE4E88C}']
    function GetRetMsg: string;
    function GetConnected: Boolean;
    procedure SetConnected(const Value: Boolean);

    function Query(ACds: TClientDataSet; ASQL: string): Boolean; overload;
    function Query(ACdsArr: array of TClientDataSet; AList: TStrings): Boolean; overload;

    function ExecSQL(ASQL: string): Boolean;
    function ExecSQLs(AList: TStrings): Boolean;
    function ApplyUpdates(ACds: TClientDataSet; ATableName, AKeyField: string): Boolean;
    function GetSQLIntegerValue(ASQL: string; var Value: Integer): Boolean;
    function GetSQLFloatValue(ASQL: string; var Value: Double): Boolean;
    function GetSQLStringValue(ASQL: string; var Value: string): Boolean;

    procedure WriteToList(ACds: TClientDataSet; AList: TStrings);

    property RetMsg: string read GetRetMsg;
    property Connected: Boolean read GetConnected write SetConnected;

    function ExecuteStoredProc(ASQL: string;
      AParams: THJYStoreProcParams): Boolean;
    function QueryStoredProc(ACds: TClientDataSet;
      ASQL: string; AParams: THJYStoreProcParams): Boolean;
  end;

implementation

end.
