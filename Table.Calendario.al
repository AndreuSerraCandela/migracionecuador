table 76255 Calendario
{
    DataPerCompany = false;

    fields
    {
        field(1; Fecha; Date)
        {
            Caption = 'Date';
            NotBlank = true;

            trigger OnValidate()
            begin
                Calend.Reset;
                Calend.SetRange("Period Type", 0); //Date
                Calend.SetRange("Period Start", Fecha);
                Calend.FindFirst;
                "Día de la semana" := Calend."Period No.";
                Ano := Date2DMY(Fecha, 3);

                Calend.Reset;
                Calend.SetRange("Period Type", 2); //Month
                Calend.SetRange("Period Start", DMY2Date(1, Date2DMY(Fecha, 2), Date2DMY(Fecha, 3)));
                Calend.FindFirst;

                Período := Calend."Period No.";
            end;
        }
        field(2; Texto; Text[30])
        {
            Caption = 'Description';
        }
        field(3; "No laborable"; Boolean)
        {
            Caption = 'No working day';
        }
        field(4; "Día de la semana"; Option)
        {
            Caption = 'Week day';
            Description = '    ,Lunes,Martes,Miércoles,Jueves,Viernes,Sabado,Domingo';
            Editable = false;
            OptionCaption = '    ,Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday';
            OptionMembers = "    ",Lunes,Martes,"Miércoles",Jueves,Viernes,Sabado,Domingo;
        }
        field(5; Semana; Integer)
        {
            Caption = 'Week';
            Editable = false;
        }
        field(6; Generado; Boolean)
        {
            Caption = 'Generated';
            Editable = false;
        }
        field(7; "Período"; Option)
        {
            Caption = 'Period';
            Description = '    ,Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Septiembre,Octubre,Noviembre,Diciembre';
            Editable = false;
            OptionCaption = '    ,January,February,March,April,May,Jun,July,August,September,October,November,December';
            OptionMembers = "    ",Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Septiembre,Octubre,Noviembre,Diciembre;
        }
        field(8; Ano; Integer)
        {
            Caption = 'Year';
            Editable = false;
        }
        field(9; Mes; Integer)
        {
            Caption = 'Month';
        }
    }

    keys
    {
        key(Key1; Fecha)
        {
            Clustered = true;
        }
        key(Key2; Ano, Mes)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        //ERROR ('No puede borrar días del calendario');
    end;

    var
        Calend: Record Date;
}

