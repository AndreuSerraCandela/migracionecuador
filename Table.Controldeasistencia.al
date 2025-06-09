table 76064 "Control de asistencia"
{
    Caption = 'Job Time attendance';

    fields
    {
        field(1; "Cod. Empleado"; Code[20])
        {
            Caption = 'Employee no.';
            NotBlank = true;
            TableRelation = Employee WHERE(Status = CONST(Active));
        }
        field(2; "Fecha registro"; Date)
        {
            Caption = 'Posting date';
            NotBlank = true;

            trigger OnValidate()
            begin
                Fecha.Reset;
                Fecha.SetRange("Period Type", Fecha."Period Type"::Date);
                Fecha.SetRange(Fecha."Period Start", "Fecha registro");
                Fecha.FindFirst;
                "Nombre dia" := Fecha."Period Name";
            end;
        }
        field(3; "Hora registro"; Time)
        {
            Caption = 'Posting time';
            NotBlank = true;
        }
        field(4; "No. tarjeta"; Code[10])
        {
            Caption = 'Card ID';
        }
        field(5; "ID Equipo"; Code[10])
        {
            Caption = 'TA system ID';
        }
        field(6; Procesado; Boolean)
        {
            Caption = 'Processced';
        }
        field(7; "Full name"; Text[60])
        {
            CalcFormula = Lookup(Employee."Full Name" WHERE("No." = FIELD("Cod. Empleado")));
            Caption = 'Full Name';
            FieldClass = FlowField;
        }
        field(8; "Job Title"; Text[60])
        {
            CalcFormula = Lookup(Employee."Job Title" WHERE("No." = FIELD("Cod. Empleado")));
            Caption = 'Job Title';
            FieldClass = FlowField;
        }
        field(9; "Fecha Entrada"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Fecha Salida"; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "1ra entrada"; Time)
        {
            Caption = 'First entry';

            trigger OnValidate()
            begin
                CalculaHoras;
            end;
        }
        field(12; "1ra salida"; Time)
        {
            Caption = 'Firs exit';

            trigger OnValidate()
            begin
                CalculaHoras;
            end;
        }
        field(13; "2da entrada"; Time)
        {
            Caption = 'Second entry';

            trigger OnValidate()
            begin
                CalculaHoras;
            end;
        }
        field(14; "2da salida"; Time)
        {
            Caption = 'Second exit';

            trigger OnValidate()
            begin
                CalculaHoras;
            end;
        }
        field(15; "Total Horas"; Duration)
        {
            Caption = 'Total hours';
            Editable = false;
        }
        field(16; "Horas receso"; Duration)
        {
            Caption = 'Hour recess';

            trigger OnValidate()
            begin
                CalculaHoras;
            end;
        }
        field(17; "Horas laboradas"; Duration)
        {
            Caption = 'Working hours';
            Editable = false;
        }
        field(18; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = 'Open,Closed';
            OptionMembers = Pendiente,Cerrada;
        }
        field(19; "Horas regulares"; Decimal)
        {
            Caption = 'Regular hours';

            trigger OnValidate()
            begin
                CalcularHorasLab;
            end;
        }
        field(20; "Horas extras al 35"; Decimal)
        {
            Caption = 'Overtime at 35';

            trigger OnValidate()
            begin
                CalcularHorasLab;
            end;
        }
        field(22; "Horas extras 100"; Decimal)
        {
            Caption = '100% overtime';

            trigger OnValidate()
            begin
                CalcularHorasLab;
            end;
        }
        field(23; "Horas feriadas"; Decimal)
        {
            Caption = 'Holiday hours';

            trigger OnValidate()
            begin
                CalcularHorasLab;
            end;
        }
        field(24; "Total Horas imputadas"; Duration)
        {
            CalcFormula = Lookup("Control de asistencia"."Total Horas" WHERE("Cod. Empleado" = FIELD("Cod. Empleado"),
                                                                              "Fecha registro" = FIELD("Fecha registro")));
            Caption = 'Total Input hours';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25; "Nombre dia"; Text[30])
        {
            Caption = 'Day';
        }
        field(26; "Horas nocturnas"; Decimal)
        {
            Caption = 'Night hours';

            trigger OnValidate()
            begin
                CalcularHorasLab;
            end;
        }
        field(27; "Metodo registro"; Option)
        {
            Caption = 'Registration method';
            DataClassification = ToBeClassified;
            OptionCaption = 'Clock,Calculated,Completed manually';
            OptionMembers = Reloj,Calculado,"Completado manualmente";
        }
    }

    keys
    {
        key(Key1; "Cod. Empleado", "Fecha registro")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        DCA.Reset;
        DCA.SetRange("Cod. Empleado", "Cod. Empleado");
        DCA.SetRange("Fecha registro", "Fecha registro");
        DCA.SetRange("Hora registro", "Hora registro");
        if DCA.FindSet then
            DCA.DeleteAll;
    end;

    var
        ConfNominas: Record "Configuracion nominas";
        Emp: Record Employee;
        CA: Record "Control de asistencia";
        DCA: Record "Distrib. Control de asis. Proy";
        Calendario: Record "Dias Festivos";
        CalTurno: Record "Shift schedule";
        Fecha: Record Date;
        Cargo: Record "Puestos laborales";
        /*      FuncionesNom: Codeunit "Funciones Nomina"; */
        Horatexto: Text[60];
        Err003: Label 'The amount of %1 exceeds the daily limit of the working day';
        Err004: Label 'You can not have %1 if %2 does not have full day';
        Err005: Label 'You can not have %1 and %2 for the same day, please correct the data';

    local procedure CalculaHoras()
    var
        Fecha: Record Date;
        Duracion: Duration;
        dHoras: Decimal;
        tHoras: Decimal;
        dMinutos: Decimal;
        tiempo: Time;
        Hor35: Decimal;
        HorasTurno: Decimal;
        NoTieneTurno: Boolean;
        FechaIniDT: DateTime;
        FechaFinDT: DateTime;
    begin
        ConfNominas.Get();
        dHoras := 0;
        "Total Horas" := 0;
        "Horas receso" := 0;
        Hor35 := 0;
        "Horas laboradas" := 0;
        "Horas extras al 35" := 0;
        "Horas extras 100" := 0;
        "Horas feriadas" := 0;
        HorasTurno := 0;
        NoTieneTurno := false;

        Fecha.Reset;
        Fecha.SetRange("Period Type", Fecha."Period Type"::Date);
        Fecha.SetRange("Period Start", "Fecha registro");
        Fecha.FindFirst;

        if ("Fecha Entrada" = 0D) and ("Fecha Salida" = 0D) then
            exit;

        if ("1ra entrada" = 0T) and ("1ra salida" = 0T) then
            exit;

        Emp.Get("Cod. Empleado");
        Cargo.Get(Emp.Departamento, Emp."Job Type Code");
        if not Cargo."Control de asistencia" then
            exit;

        if Emp.Shift <> '' then begin
            CalTurno.Reset;
            CalTurno.SetRange("Codigo turno", Emp.Shift);
            CalTurno.FindFirst;
            CalTurno.TestField("Hora Inicio");
            CalTurno.TestField("Hora Fin");

            FechaIniDT := CreateDateTime("Fecha Entrada", CalTurno."Hora Inicio");
            FechaFinDT := CreateDateTime("Fecha Entrada", "1ra entrada");
            /*             dHoras := FuncionesNom.CalculoEntreFechaDotNet('H', FechaIniDT, FechaFinDT);
                        dMinutos := FuncionesNom.CalculoEntreFechaDotNet('N', FechaIniDT, FechaFinDT); */
            if dMinutos > 60 then begin
                dHoras += 1;
                dMinutos := dMinutos mod 60;
                dMinutos /= 100;
                dHoras += dMinutos;
            end;
        end
        else begin
            Clear(CalTurno);
            NoTieneTurno := true;
            if Fecha."Period No." = 6 then
                HorasTurno := 4
            else
                HorasTurno := 8;
        end;

        if ("1ra entrada" <> 0T) and ("1ra salida" <> 0T) and
           ("2da entrada" = 0T) and ("2da salida" = 0T) then begin
            FechaIniDT := CreateDateTime("Fecha Entrada", "1ra entrada");
            FechaFinDT := CreateDateTime("Fecha Salida", "1ra salida");
            /*       dHoras := FuncionesNom.CalculoEntreFechaDotNet('H', FechaIniDT, FechaFinDT);
                  dMinutos := FuncionesNom.CalculoEntreFechaDotNet('N', FechaIniDT, FechaFinDT); */
            if dMinutos > 60 then begin
                dHoras += 1;
                dMinutos := dMinutos mod 60;
                dMinutos /= 100;
                dHoras += dMinutos;
            end;
        end
        else
            if ("1ra entrada" <> 0T) and ("1ra salida" <> 0T) and
               ("2da entrada" <> 0T) and ("2da salida" <> 0T) then begin
                FechaIniDT := CreateDateTime("Fecha Entrada", "1ra entrada");
                FechaFinDT := CreateDateTime("Fecha Salida", "1ra salida");
                /*           dHoras := FuncionesNom.CalculoEntreFechaDotNet('H', FechaIniDT, FechaFinDT);
                          dMinutos := FuncionesNom.CalculoEntreFechaDotNet('N', FechaIniDT, FechaFinDT);

                          FechaIniDT := CreateDateTime("Fecha Entrada", "2da entrada");
                          FechaFinDT := CreateDateTime("Fecha Salida", "2da salida");
                          dHoras += FuncionesNom.CalculoEntreFechaDotNet('H', FechaIniDT, FechaFinDT);
                          dMinutos += FuncionesNom.CalculoEntreFechaDotNet('N', FechaIniDT, FechaFinDT); */
                if dMinutos > 60 then begin
                    dHoras += 1;
                    dMinutos := dMinutos mod 60;
                    dMinutos /= 100;
                    dHoras += dMinutos;
                end;
            end;

        if ("2da entrada" <> 0T) and ("1ra salida" = 0T) then
            exit;

        if dHoras <= 0 then
            exit;

        tHoras := dHoras; // Para poder saber las horas de receso

        if "1ra entrada" >= 180000T then begin
            if dHoras >= 8 then begin
                "Horas nocturnas" := 8;
                dHoras -= 8;
            end
            else begin
                "Horas nocturnas" := dHoras;
                dHoras := 0;
            end;
        end
        else begin
            if dHoras >= 8 then begin
                "Horas regulares" := 8;
                dHoras -= 8 + ConfNominas."Horas de almuerzo";
            end
            else begin
                "Horas regulares" := dHoras;
                dHoras := 0;
            end;
        end;

        if dHoras > 0 then begin
            if dHoras >= 3 then begin
                "Horas extras al 35" := 3;
                dHoras -= 3;
            end
            else begin
                "Horas extras al 35" := dHoras - ConfNominas."Horas de almuerzo";
                dHoras := 0;
            end
        end;

        if dHoras > 0 then begin
            "Horas extras 100" := dHoras;
            dHoras := 0;
        end;


        if ("1ra entrada" <> 0T) and ("1ra salida" <> 0T) then begin
            "Total Horas" := "1ra salida" - "1ra entrada";
            if ("2da entrada" <> 0T) and ("2da salida" <> 0T) then
                "Total Horas" := Abs("2da salida" - "1ra entrada");
        end
        else
            if ("2da entrada" <> 0T) and ("2da salida" <> 0T) then
                "Total Horas" := Abs("2da salida" - "2da entrada");

        if ("1ra entrada" <> 0T) and ("1ra salida" <> 0T) and
           ("2da entrada" <> 0T) and ("2da salida" <> 0T) then
            "Horas receso" := "2da entrada" - "1ra salida"
        else
            if ("1ra entrada" <> 0T) and ("1ra salida" <> 0T) and (tHoras > 8) then
                Evaluate("Horas receso", Format(ConfNominas."Horas de almuerzo"))
            else
                if ("1ra entrada" <> 0T) and ("1ra salida" <> 0T) and
                   ("2da entrada" <> 0T) and ("2da salida" <> 0T) then
                    "Horas receso" := "2da entrada" - "1ra salida";



        if ("1ra entrada" <> 0T) and ("1ra salida" <> 0T) and ("2da entrada" <> 0T) and ("2da salida" <> 0T) then
            Horatexto := Format(("1ra salida" - "1ra entrada") + ("2da salida" - "2da entrada") - ("2da entrada" - "1ra salida"));

        if "Total Horas" <> 0 then
            "Horas laboradas" := Abs("Total Horas" - "Horas receso");

        Horatexto := Format("Horas laboradas");
        if Horatexto = '' then
            exit;
        /*
        IF STRPOS(UPPERCASE(Horatexto),'HO') <> 0 THEN
           EVALUATE(dHoras,DELCHR(COPYSTR(Horatexto,1,STRPOS(UPPERCASE(Horatexto),'HO')-1),'=',DELCHR(Horatexto,'=',' 1234567890')));
        
        IF (STRPOS(UPPERCASE(Horatexto),'HO') <> 0 ) AND (STRPOS(UPPERCASE(Horatexto),'MIN') <> 0) THEN
          BEGIN
           Horatexto := COPYSTR(Horatexto,STRPOS(UPPERCASE(Horatexto),'HO'),STRPOS(UPPERCASE(Horatexto),'MIN')-1);
            Horatexto := DELCHR(Horatexto,'=','abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ');
            EVALUATE(dMinutos,Horatexto);
          END
        ELSE
        IF STRPOS(UPPERCASE(Horatexto),'MIN') <> 0 THEN
           EVALUATE(dMinutos,DELCHR(COPYSTR(Horatexto,1,STRPOS(UPPERCASE(Horatexto),'MIN')-1),'=',DELCHR(Horatexto,'=',' 1234567890')));
        
        dHoras := "Total Horas" / 3600;
        dHoras /= 1000;
        IF "Horas receso" <> 0 THEN
          dHoras -= 1;
        
        IF dHoras > 24 THEN
           dHoras := dHoras / 100;
        
        //MESSAGE('%1 %2',dHoras,dMinutos);
        IF NOT Calendario.GET("Fecha registro") THEN
           Calendario.INIT;
        
        "Horas extras al 35" := Hor35;
        
        IF Calendario.Fecha <> 0D THEN
           BEGIN
            "Horas feriadas" := dHoras;
            "Horas regulares" := 0;
           END
        ELSE
          BEGIN
           IF Fecha."Period No." = 7 THEN
              BEGIN
                "Horas feriadas" += dHoras;
                "Horas regulares" := 0;
              END
           ELSE
           IF Fecha."Period No." = 6 THEN
              BEGIN
              "Horas regulares" := dHoras;
        
              IF dHoras > 4 THEN
                BEGIN
                  "Horas regulares" := 4;
              //    "Horas extras al 35" += dHoras - 4 - Hor35;
                  "Horas feriadas" += dHoras - 4;
                END;
            END
            ELSE
              BEGIN
                "Horas regulares" := dHoras;
                 "Horas regulares" := ROUND(dHoras,0.01);
        
                IF ((dHoras > HorasTurno) AND (dHoras <= HorasTurno + 1)) OR ((Hor35 <> 0) AND (dHoras > HorasTurno)) THEN
                    BEGIN
                    "Horas extras al 35" += ROUND(dHoras - HorasTurno - Hor35,0.01);
                    "Horas regulares" := ROUND(HorasTurno,0.01);
                    END
                ELSE
                IF dHoras > HorasTurno + 1 THEN
                  BEGIN
                    IF (dHoras > HorasTurno) THEN
                       BEGIN
                        "Horas extras al 35" += dHoras - HorasTurno;
                        IF "Horas extras al 35" > 3 THEN
                           "Horas extras al 35" := 3;
                        dHoras -= "Horas extras al 35";
                       END;
        
                    "Horas regulares" := ROUND(HorasTurno,0.01);
                    dHoras := dHoras - HorasTurno;
        
                    IF dHoras > 0 THEN
                      "Horas extras nocturnas" := dHoras
                    ELSE
                      dHoras := 0;
                  END
                ELSE
                IF (dHoras <> 0) AND (Hor35 <> 0) THEN //16/05/2019
                   BEGIN
                    dHoras -= Hor35;
                    "Horas regulares" := ROUND(dHoras,0.01);
                   END;
              END;
          END;
          */
        //MESSAGE('%1 %2 %3 %4',"Horas nocturnas","Horas extras al 35");
        Horatexto := Format("Total Horas");

        /*
        Fecha.RESET;
        Fecha.SETRANGE("Period Type",Fecha."Period Type"::Date);
        Fecha.SETRANGE("Period Start","Fecha registro");
        Fecha.FINDFIRST;
        IF Fecha."Period No." <> 6 THEN
           BEGIN
            EVALUATE(Duracion,FORMAT(8));
            IF "Total Horas" /1000 /3600 >= 9 THEN
               "Horas extras" := "Horas laboradas" - Duracion;
           END
        ELSE
        IF Fecha."Period No." = 7 THEN
           "Horas extras" := "Horas laboradas"
        ELSE
        IF Fecha."Period No." = 6 THEN
           EVALUATE(Duracion,FORMAT(4));
           IF "Horas laboradas" >= 4 THEN
              "Horas extras" := "Horas laboradas" - Duracion;
        */

    end;

    local procedure CalcularHorasLab()
    var
        CA: Record "Control de asistencia";
        DCP: Record "Distrib. Control de asis. Proy";
        Fecha: Record Date;
        TotHoras: Decimal;
        DurHoras: Duration;
    begin
        Fecha.Reset;
        Fecha.SetRange("Period Type", Fecha."Period Type"::Date);
        Fecha.SetRange("Period Start", "Fecha registro");
        Fecha.FindFirst;
        if Fecha."Period No." <> 6 then begin
            if "Horas regulares" > 8 then
                Error(StrSubstNo(Err003, FieldCaption("Horas regulares")));
            if "Horas extras al 35" > 12 then
                Error(StrSubstNo(Err003, FieldCaption("Horas extras al 35")));
            if "Horas extras 100" > 8 then
                Error(StrSubstNo(Err003, FieldCaption("Horas extras 100")));
            /*Validar despues
                 IF ("Horas extras al 35" <> 0) AND ("Horas regulares" = 0) THEN
                    ERROR(STRSUBSTNO(Err004,FIELDCAPTION("Horas extras al 35"),FIELDCAPTION("Horas regulares")))
                 ELSE
                 IF ("Horas extras al 35" <> 0) AND ("Horas regulares" < 8) THEN
                    ERROR(STRSUBSTNO(Err004,FIELDCAPTION("Horas extras al 35"),FIELDCAPTION("Horas regulares")));
            */
            if ("Horas regulares" <> 0) and ("Horas extras 100" <> 0) then
                Error(StrSubstNo(Err005, FieldCaption("Horas regulares"), FieldCaption("Horas extras 100")));
        end
        else
            if Fecha."Period No." = 7 then begin
                //Controlar que no se digiten horas regulares ni al 35
                //   "Horas extras" := "Horas laboradas"
            end
            else
                if Fecha."Period No." = 6 then begin
                    if "Horas regulares" > 4 then
                        Error(StrSubstNo(Err003, FieldCaption("Horas regulares")));
                    if "Horas extras al 35" > 0 then
                        Error(StrSubstNo(Err003, FieldCaption("Horas extras al 35")));
                end;

        "Horas laboradas" := "Horas regulares" + "Horas extras al 35" + "Horas feriadas" + "Horas extras 100";
        Evaluate(DurHoras, Format("Horas regulares"));

        CA.Reset;
        CA.SetRange("Cod. Empleado", "Cod. Empleado");
        CA.SetRange("Fecha registro", "Fecha registro");
        CA.SetRange("Hora registro", "Hora registro");
        CA.FindFirst;
        /*IF DurHoras > CA."Horas laboradas" THEN
           ERROR(STRSUBSTNO(Err001,FIELDCAPTION("Horas laboradas"),FIELDCAPTION("fecha registro"),"fecha registro",
                            FIELDCAPTION("Hora registro"),"Hora registro"));
        */

        TotHoras := 0;
        DCP.Reset;
        DCP.SetRange("Cod. Empleado", "Cod. Empleado");
        DCP.SetRange("Fecha registro", "Fecha registro");
        DCP.SetRange("Hora registro", "Hora registro");
        //DCP.SETFILTER("No. Linea",'<>%1',"No. Linea");
        if DCP.FindSet then
            repeat
                TotHoras += DCP."Horas laboradas";
            until DCP.Next = 0;
        /*
        TotHoras += "Horas laboradas";
        EVALUATE(DurHoras,FORMAT(TotHoras));
        IF DurHoras > CA."Horas laboradas" THEN
           ERROR(STRSUBSTNO(Err001,FIELDCAPTION("Horas laboradas"),FIELDCAPTION("Fecha registro"),"Fecha registro",
                            FIELDCAPTION("Hora registro"),"Hora registro"));
        */

    end;

    local procedure TimeToDecimal(HoraInicio: Time; HoraFin: Time) dHoras: Decimal
    var
        Horatexto: Text[100];
        dMinutos: Decimal;
    begin
        if (HoraInicio < HoraFin) and (HoraInicio <> 0T) and (HoraFin <> 0T) then begin
            "Total Horas" := Abs(HoraFin - HoraInicio);
            Horatexto := Format("Total Horas");
            if Horatexto <> '' then begin
                if StrPos(UpperCase(Horatexto), 'HO') <> 0 then
                    Evaluate(dHoras, DelChr(CopyStr(Horatexto, 1, StrPos(UpperCase(Horatexto), 'HO') - 1), '=', DelChr(Horatexto, '=', ' 1234567890')));

                if (StrPos(UpperCase(Horatexto), 'HO') <> 0) and (StrPos(UpperCase(Horatexto), 'MIN') <> 0) then begin
                    Horatexto := CopyStr(Horatexto, StrPos(UpperCase(Horatexto), 'HO'), StrPos(UpperCase(Horatexto), 'MIN') - 1);
                    Horatexto := DelChr(Horatexto, '=', 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ');
                    Evaluate(dMinutos, Horatexto);
                end
                else
                    if StrPos(UpperCase(Horatexto), 'MIN') <> 0 then
                        Evaluate(dMinutos, DelChr(CopyStr(Horatexto, 1, StrPos(UpperCase(Horatexto), 'MIN') - 1), '=', DelChr(Horatexto, '=', ' 1234567890')));

                if dHoras >= 0 then begin
                    dHoras := "Total Horas" / 3600;
                    dHoras /= 1000;
                    if "Horas receso" <> 0 then
                        dHoras -= 1;

                    if dHoras > 24 then
                        dHoras := dHoras / 100;
                    dHoras := Round(dHoras, 0.01);
                end;
            end;
        end;
    end;
}

