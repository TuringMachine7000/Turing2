unit TuringMod;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils;



type TuringCommand = class
  private

  public
    currState : Integer;
    currSymbol : Char;
    nextSymbol : Char;
    nextState : Integer;
    orientation : Integer;//-1, (0) и 1
  end;

type

{ TuringMachine }

 TuringMachine = class
  private
    tape : String;     //Лента
    position : Integer;//Текущая позиция курсора
    state : Integer;   //текущее состояние
    theProgram : TList;//список комманд
  public
    onStart : TNotifyEvent;
    onStep : TNotifyEvent;
    onStop : TNotifyEvent;
    onError : TNotifyEvent;
    last : Integer;
    function getRightCommand : TuringCommand;
    function getState: Integer;
    function getTape: String;
    function getPosition : Integer;
    function getTheProgram : TList;

    procedure setTape (t : String);
    procedure setPosition (p : Integer);
    procedure addCommand (x : TuringCommand);
    procedure start(s:String);
    procedure Step ;
    procedure clearprogram;
    constructor Create;

  end;

implementation


    function TuringMachine.getState : Integer;
    begin
         result := state;
    end;
    function TuringMachine.getTape : String;
    begin
         result := tape;
    end;

    function TuringMachine.getPosition : Integer;
    begin
         result := position;
    end;

    function TuringMachine.getTheProgram : TList;
    begin
         result := theProgram;
    end;



    procedure TuringMachine.setTape (t : String);
    begin
         tape := t;
    end;

    procedure TuringMachine.setPosition(p: Integer);
    begin
      position := p;
    end;

    procedure TuringMachine.addCommand(x : TuringCommand);
    begin
         theProgram.add(x);
    end;

    procedure TuringMachine.start(s: String);
    begin
      tape := s;
      position:=1;
      state := 1;
    end;

    function TuringMachine.getRightCommand : TuringCommand;
    var i : Integer;
    var s :Integer;
    var t : String;
    var p :Integer;
    var tp : TList;
    begin
         s := getState();
         t := getTape();
         p := getPosition();
         tp := getTheProgram();
         result := nil;
         for i := 0 to theProgram.Count-1 do
             if ((t[p] = TuringCommand(tp[i]).currSymbol) and (s = TuringCommand(tp[i]).currState)) then
                begin
                       result := TuringCommand(tp[i]);
                       break;
                end;
    end;

    procedure TuringMachine.Step;
    var rc : TuringCommand;
    begin
      rc := getRightCommand();
      if (getState = 0) then
      begin
         if Assigned(onStop) then onStop(self);
         exit;
      end;
      if (rc = nil) then
      begin
         if (Assigned(onError)) then
            begin
                 onError(self);
            end;
         exit;
      end;
      if (tape[position] = '#')  then setTape(tape + '#');
      tape[position] := rc.nextSymbol;
      state := rc.nextState;

      last := position-1;
      position := position + rc.orientation;

    end;

    procedure TuringMachine.clearprogram;
    begin
      theProgram.Clear;
    end;


    constructor TuringMachine.Create;
    begin
      TheProgram := TList.Create;
      state := 1;
      position := 1;
      last := 0;
    end;




end.


