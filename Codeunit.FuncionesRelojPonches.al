// codeunit 76032 "Funciones Reloj Ponches"
// {
//     // Base de datos   Provider
//     // SQL             SQLOLEDB;


//     trigger OnRun()
//     begin
//     end;

//     var
//         Text000: Label 'End of processing';
//         Text001: Label 'Reading  #1########## @2@@@@@@@@@@@@@';
//         Err001: Label 'Cannot create ADO Connection automation variable.';
//         Err002: Label 'Cannot create ADO Recordset automation variable.';
//         Err003: Label 'Cannot create ADO Stream automation variable.';
//         Err004: Label 'Cannot create ADO Command automation variable';
//         Empl: Record Employee;
//         tmpLogReloj: Record "Punch log";
//         LogReloj: Record "Punch log";
//         ParamReloj: Record "Parametros Reloj Control Asist";
//         ADOConnection: Automation;
//         ADORecSet: Automation;
//         ADOStream: Automation;
//         ADOCommand: Automation;
//         RecordsAffected: Text[1024];
//         RSOption: Integer;
//         ConnString: Text[1024];
//         SPName: Text[1024];
//         ParamValues: array[10] of Text[1024];
//         SQLString: Text;
//         RsCursor: Integer;
//         RsLock: Integer;
//         ActualSizeField: Integer;
//         NoEmpleado: Code[20];
//         IDCard: Code[20];
//         FirstTime: Boolean;
//         EmpAnt: Code[20];
//         Fecha: Text;
//         Hora: Text;
//         IDEquipo: Code[10];
//         IDEquipoAnt: Code[10];
//         DD: Integer;
//         MM: Integer;
//         AA: Integer;
//         Window: Dialog;
//         CounterTotal: Integer;
//         Counter: Integer;
//         FechaHor: DateTime;


//     procedure ReadEmp()
//     begin
//         FirstTime := true;
//         ParamReloj.Find('-');
//         CounterTotal := ParamReloj.Count;
//         Window.Open(Text001);
//         repeat
//             SetConnParams;
//             Counter := Counter + 1;
//             Window.Update(1, ParamReloj.Description);
//             Window.Update(2, Round(Counter / CounterTotal * 10000, 1));

//             ReadAdoRecords;
//             CloseAll;
//         until ParamReloj.Next = 0;


//         Window.Close;
//         Message(Text000);
//     end;

//     local procedure SetConnParams()
//     begin
//         if IsClear(ADOConnection) then begin
//             if not Create(ADOConnection, false, true) then
//                 Error(Err001);
//         end;

//         if IsClear(ADORecSet) then begin
//             if not Create(ADORecSet, false, true) then
//                 Error(Err002);
//         end;

//         if IsClear(ADOStream) then begin
//             if not Create(ADOStream, false, true) then
//                 Error(Err003);
//         end;

//         if IsClear(ADOCommand) then begin
//             if not Create(ADOCommand, false, true) then
//                 Error(Err004);
//         end;

//         ConnString := 'Provider=' + ParamReloj.Provider + 'Data Source=' + ParamReloj."Data Source" + 'Initial Catalog=' + ParamReloj."Initial Catalog" +
//                       'User ID=' + ParamReloj.User + ';Password=' + ParamReloj.Password + ';';
//         //'Provider=SQLOLEDB;Data Source=(local);' +
//         //'Initial Catalog=a1;User ID=dynasoft;Password=Dynasoft2007!;';

//         //MESSAGE(ConnString);
//         ADOConnection.ConnectionString(ConnString);
//         ADOConnection.Open;
//     end;

//     local procedure ReadAdoRecords()
//     var
//         NoRecords: Integer;
//         Cont: Integer;
//         FechaPrueba: Date;
//     begin
//         //FechaPrueba := DMY2DATE(30,3,2015);

//         SQLString := 'SELECT * FROM ' + ParamReloj."Nombre tabla ponchador" + ' WHERE ' + ParamReloj."Nombre campo filtro de fecha" + ' between ' + '''' + Format(CalcDate('-10D', WorkDate), 0, '<Year4>-<Month,2>-<Day,2>') + '''' +
//         ' and ' + '''' + Format(CalcDate('-1D', WorkDate), 0, '<Year4>-<Month,2>-<Day,2>') + '''' + ' and EquNo=' + ParamReloj."ID Campo ID Equipo";
//         //SQLString := 'SELECT * FROM ' +  ParamReloj."Nombre tabla ponchador" + ' WHERE RecDate = ' + '''' + FORMAT(FechaPrueba,0,'<Year4>-<Month,2>-<Day,2>') + '''';
//         //' and EmplID = ' +  '''' + Empl."No." + '''';
//         //MESSAGE(SQLString);
//         RsCursor := 2;
//         RsLock := 3;

//         ADORecSet.Open(SQLString, ADOConnection, RsCursor, RsLock);

//         NoRecords := ADORecSet.RecordCount;

//         if NoRecords <> 0 then
//             if not (ADORecSet.BOF) and not (ADORecSet.EOF) then begin
//                 ADORecSet.MoveFirst;
//                 repeat
//                     //Cod. Empleado
//                     Clear(NoEmpleado);
//                     LeeCampo(ParamReloj."ID Campo Cod. Empleado");
//                     /*
//                     ActualSizeField := ADORecSet.Fields.Item(ParamReloj."ID Campo Cod. Empleado").ActualSize;
//                     IF ActualSizeField <> 0 THEN //No NULL
//                       BEGIN
//                         ADOStream.Open;
//                         ADOStream.WriteText(ADORecSet.Fields.Item(ParamReloj."ID Campo Cod. Empleado").Value);
//                         ADOStream.Position:= 0;
//                         */
//                     NoEmpleado := ADOStream.ReadText;
//                     ADOStream.Close;
//                     //END;

//                     //ID tarjeta
//                     Clear(IDCard);
//                     LeeCampo(ParamReloj."ID Campo Cod. tarjeta");
//                     /*      ActualSizeField := ADORecSet.Fields.Item(ParamReloj."ID Campo Cod. tarjeta").ActualSize;
//                           IF ActualSizeField <> 0 THEN //No NULL
//                             BEGIN
//                               ADOStream.Open;
//                               ADOStream.WriteText(ADORecSet.Fields.Item(ParamReloj."ID Campo Cod. tarjeta").Value);
//                               ADOStream.Position:= 0;
//                               */
//                     IDCard := ADOStream.ReadText;
//                     ADOStream.Close;
//                     //END;

//                     //Fecha del ponche
//                     Clear(Fecha); //Fecha
//                     LeeCampo(ParamReloj."ID Campo Fecha registro");
//                     /*
//                     ActualSizeField := ADORecSet.Fields.Item(ParamReloj."ID Campo Fecha registro").ActualSize;
//                     IF ActualSizeField <> 0 THEN //No NULL
//                       BEGIN
//                         ADOStream.Open;
//                         ADOStream.WriteText(ADORecSet.Fields.Item(ParamReloj."ID Campo Fecha registro").Value);
//                         ADOStream.Position:= 0;*/
//                     Fecha := Format(ADOStream.ReadText);
//                     ADOStream.Close;
//                     //END;

//                     //Hora
//                     Clear(Hora);
//                     LeeCampo(ParamReloj."ID Campo Hora registro");
//                     /*
//                     ActualSizeField := ADORecSet.Fields.Item(ParamReloj."ID Campo Hora registro").ActualSize;
//                     IF ActualSizeField <> 0 THEN //No NULL
//                       BEGIN
//                         ADOStream.Open;
//                         ADOStream.WriteText(ADORecSet.Fields.Item(ParamReloj."ID Campo Hora registro").Value);
//                         ADOStream.Position:= 0;*/
//                     Hora := ADOStream.ReadText;
//                     ADOStream.Close;
//                     //END;
//                     /*
//                           //ID ponchador
//                           CLEAR(IDCard);
//                           ActualSizeField := ADORecSet.Fields.Item(ParamReloj."ID Campo ID Equipo").ActualSize;
//                           IF ActualSizeField <> 0 THEN //No NULL
//                             BEGIN
//                               ADOStream.Open;
//                               ADOStream.WriteText(ADORecSet.Fields.Item(ParamReloj."ID Campo ID Equipo").Value);
//                               ADOStream.Position:= 0;
//                               IDEquipo := ADOStream.ReadText;
//                               ADOStream.Close;
//                             END;
//                     */
//                     ADORecSet.MoveNext;

//                     if not Empl.Get(NoEmpleado) then begin
//                         Empl.SetRange("ID Control de asistencia", NoEmpleado);
//                         if Empl.FindFirst then
//                             NoEmpleado := Empl."No.";
//                     end;
//                     tmpLogReloj.Init;
//                     tmpLogReloj."Cod. Empleado" := NoEmpleado;
//                     Evaluate(DD, CopyStr(Fecha, 9, 2));
//                     Evaluate(MM, CopyStr(Fecha, 6, 2));
//                     Evaluate(AA, CopyStr(Fecha, 1, 4));
//                     tmpLogReloj."Fecha registro" := DMY2Date(DD, MM, AA);
//                     Evaluate(tmpLogReloj."Hora registro", Hora);
//                     tmpLogReloj."No. tarjeta" := IDCard;
//                     tmpLogReloj."ID Equipo" := IDEquipo;
//                     if tmpLogReloj.Insert then;

//                 //     MESSAGE('%1 %2',NoEmpleado,IDCard);
//                 until ADORecSet.EOF;
//             end;

//     end;

//     local procedure LeeCampo(IDCampo: Integer)
//     begin
//         ActualSizeField := ADORecSet.Fields.Item(IDCampo).ActualSize;
//         if ActualSizeField <> 0 then //No NULL
//           begin
//             ADOStream.Open;
//             ADOStream.WriteText(ADORecSet.Fields.Item(IDCampo).Value);
//             ADOStream.Position := 0;
//         end;
//     end;

//     local procedure CloseAll()
//     begin
//         if not IsClear(ADORecSet) then
//             ADORecSet.Close;
//         if not IsClear(ADOConnection) then
//             ADOConnection.Close;
//     end;


//     procedure InsertaEmpHMW()
//     begin
//         //Empl.SETRANGE("Last Date Modified",TODAY);
//         FirstTime := true;
//         SetConnParams;
//         Counter := 0;
//         Window.Open(Text001);

//         Empl.Get('1160');
//         CounterTotal := Empl.Count;
//         Empl.FindSet;
//         repeat
//             Counter := Counter + 1;
//             Window.Update(1, Empl."Full Name");
//             Window.Update(2, Round(Counter / CounterTotal * 10000, 1));
//         /*
//        ADOCommand.Parameters.Add(
//               cmd.Parameters.Add("@FirstName", SqlDbType.VarChar, 50).Value = firstName;
//               cmd.Parameters.Add("@Lastname", SqlDbType.VarChar, 50).Value = lastName;
//               cmd.Parameters.Add("@Username", SqlDbType.VarChar, 50).Value = userName;
//               cmd.Parameters.Add("@Password", SqlDbType.VarChar, 50).Value = password;
//               cmd.Parameters.Add("@Age", SqlDbType.Int).Value = age;
//               cmd.Parameters.Add("@Gender", SqlDbType.VarChar, 50).Value = gender;
//               cmd.Parameters.Add("@Contact", SqlDbType.VarChar, 50).Value = contact;

//               // open connection, execute INSERT, close connection
//               cn.Open();
//               cmd.ExecuteNonQuery();

//               cn.Close();
//           */
//         until Empl.Next = 0;

//         CloseAll;
//         Window.Close;

//         Message(Text000);

//     end;
// }

