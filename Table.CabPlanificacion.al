table 76290 "Cab. Planificacion"
{

    fields
    {
        field(1; "Cod. Promotor"; Code[20])
        {
            TableRelation = "Salesperson/Purchaser" WHERE(Tipo = FILTER(Vendedor | Supervisor));

            trigger OnValidate()
            begin

                if "Cod. Promotor" <> '' then begin
                    Promotor.Get("Cod. Promotor");
                    "Nombre promotor" := Promotor.Name;
                end;
            end;
        }
        field(2; Fecha; Date)
        {
        }
        field(3; Hora; Time)
        {
        }
        field(4; "Fecha Inicial"; Date)
        {
        }
        field(5; "Fecha Final"; Date)
        {
        }
        field(6; Semana; Integer)
        {
            NotBlank = true;

            trigger OnLookup()
            begin

                date1.Reset;
                date1.SetRange("Period Type", 1); //Semana
                date1.SetRange("Period Start", Today, CalcDate('+2' + Sem, Today));
                //date1.SETRANGE("Period Start",CALCDATE('+1' + Sem,TODAY),CALCDATE('+2' + Sem,TODAY));
                date1.FindSet;

                fFechas.SetTableView(date1);
                //fFechas.SETRECORD(date1);
                fFechas.LookupMode(true);
                if fFechas.RunModal = ACTION::LookupOK then begin
                    fFechas.GetRecord(date1);
                    Validate(Semana, date1."Period No.");
                end;

                Clear(fFechas);
            end;

            trigger OnValidate()
            begin

                date1.Reset;
                date1.SetRange("Period Type", date1."Period Type"::Week);
                date1.SetRange("Period Start", CalcDate('-2' + Sem, WorkDate), CalcDate('+52' + Sem, WorkDate));
                date1.SetRange("Period No.", Semana);
                date1.FindFirst;

                "Fecha Inicial" := date1."Period Start";
                "Fecha Final" := NormalDate(date1."Period End");

                if Insert(true) then;
                /*
                SETRANGE("Filtro Fecha","Fecha Inicial","Fecha Final");
                
                PPV.RESET;
                PPV.SETRANGE("Cod. Promotor","Cod. Promotor");
                PPV.SETRANGE("Fecha Proxima Visita","Fecha Inicial","Fecha Final");
                IF PPV.FINDSET THEN
                   REPEAT
                //    message('%1 %2 %3 %4',PPV."Fecha Proxima Visita");
                    PPV2.INIT;
                    PPV2.VALIDATE("Cod. Promotor","Cod. Promotor");
                    PPV2.VALIDATE(Semana,Semana);
                    PPV2.VALIDATE("Cod. Colegio",PPV."Cod. Colegio");
                    PPV2.VALIDATE(Fecha,Fecha);
                    PPV2.VALIDATE("Fecha Visita",PPV."Fecha Proxima Visita");
                
                
                    IF PPV2.INSERT(TRUE) THEN;
                   UNTIL PPV.NEXT = 0;
                */

            end;
        }
        field(7; "Nombre promotor"; Text[60])
        {
            Editable = false;
        }
        field(8; Estado; Option)
        {
            OptionCaption = ' ,Planned,Executed';
            OptionMembers = " ",Planificado,Ejecutado;
        }
        field(9; "Filtro Fecha"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(10; Ano; Integer)
        {
            Caption = 'Year';
        }
    }

    keys
    {
        key(Key1; "Cod. Promotor", Ano, Semana)
        {
            Clustered = true;
        }
        key(Key2; Fecha)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin

        if Estado > 1 then
            Error(StrSubstNo(Err001, FieldName(Estado), Estado));

        PPV2.Reset;
        PPV2.SetRange("Cod. Promotor", "Cod. Promotor");
        PPV2.SetRange(Semana, Semana);
        if PPV2.FindSet(true) then
            repeat
                if PPV2.Estado = 2 then
                    Error(Err002);
                PPV2.Delete(true);
            until PPV2.Next = 0;
    end;

    trigger OnInsert()
    begin
        if Fecha = 0D then
            Fecha := Today;
        Ano := Date2DMY(Fecha, 3);
    end;

    var
        Promotor: Record "Salesperson/Purchaser";
        date1: Record Date;
        Date2: Record Date;
        PPV: Record "Promotor - Planif. Visita";
        PPV2: Record "Promotor - Planif. Visita";
        fFechas: Page Fechas;
        Sem: Label 'W';
        Err001: Label '%1 can''t be %2';
        Err002: Label 'You can''t delete lines with School with completed dates';
        fInicio: Date;
        FFin: Date;
}

