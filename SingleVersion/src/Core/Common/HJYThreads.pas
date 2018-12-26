(*
  ���ܸ�������װ�򵥵��̣߳��߳�ִ�еķ����ɴ���ʱ����
  ���÷�ʽ��
    THJYThread.Create(
      procedure()
      begin
        //�߳�ִ�д���
      end,

      procedure()
      begin
        //�߳�ִ����ɺ������
      end
    );
*)

unit HJYThreads;

interface

uses Classes;

type
  THJYThread = class(TThread)
  private
    FPrc: TThreadProcedure;
    FOnTerminate: TThreadProcedure;
    FSynchronize: Boolean;
  protected
    procedure Execute; override;
    procedure DoTerminate; override;
  public
    constructor Create(APrc: TThreadProcedure; ASynchronize: Boolean = False); overload;
    constructor Create(APrc, AOnTerminate: TThreadProcedure); overload;
    constructor Create(APrc, AOnTerminate: TThreadProcedure; ASynchronize: Boolean); overload;
  end;

implementation

{ THJYThread }

constructor THJYThread.Create(APrc: TThreadProcedure; ASynchronize: Boolean);
begin
  Self.FreeOnTerminate := True;
  Self.FPrc := APrc;
  FSynchronize := ASynchronize;
  inherited Create(False);
end;

constructor THJYThread.Create(APrc: TThreadProcedure; AOnTerminate: TThreadProcedure);
begin
  Self.FreeOnTerminate := True;
  Self.FPrc := APrc;
  FSynchronize := False;
  FOnTerminate := AOnTerminate;
  inherited Create(False);
end;

constructor THJYThread.Create(APrc, AOnTerminate: TThreadProcedure; ASynchronize: Boolean);
begin
  Self.FreeOnTerminate := True;
  Self.FPrc := APrc;
  FSynchronize := ASynchronize;
  FOnTerminate := AOnTerminate;
  inherited Create(False);
end;

procedure THJYThread.Execute;
begin
  Self.FreeOnTerminate := True;
  try
    if FSynchronize then
      Synchronize(FPrc)
    else
      FPrc;
  except
  end;
end;

procedure THJYThread.DoTerminate;
begin
  if Assigned(FOnTerminate) then
    FOnTerminate;
end;

end.