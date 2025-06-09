table 76409 "Dias Festivos"
{
    Caption = 'Hollydays';
    DataPerCompany = false;

    fields
    {
        field(1; Fecha; Date)
        {

            trigger OnValidate()
            begin
                SysDate.Reset;
                SysDate.SetRange("Period Start", Fecha);
                SysDate.FindFirst;
                "Dia Semana" := SysDate."Period No.";

                SysDate.Reset;
                SysDate.SetRange("Period Type", SysDate."Period Type"::Month);
                SysDate.SetRange("Period Start", DMY2Date(1, Date2DMY(Fecha, 2), Date2DMY(Fecha, 3)));
                SysDate.FindFirst;
                Mes := SysDate."Period No.";
            end;
        }
        field(2; "Dia Semana"; Option)
        {
            Caption = 'Day of the week';
            Description = '    ,Lunes,Martes,Miércoles,Jueves,Viernes,Sábado,Domingo';
            Editable = false;
            OptionCaption = ' ,Monday,Tuesday,Wednesday,Thursday,Friday,Saturday,Sunday';
            OptionMembers = " ",Lunes,Martes,"Miércoles",Jueves,Viernes,"Sábado",Domingo;
        }
        field(3; Texto; Text[30])
        {
        }
        field(4; Mes; Option)
        {
            Caption = 'Month';
            Description = '   ,Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Septiembre,Octubre,Noviembre,Diciembre';
            OptionCaption = '  ,January,February,March,April,May,Jun,July,August,Septiember,Octouber,November,December';
            OptionMembers = " ",Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Septiembre,Octubre,Noviembre,Diciembre;
        }
        field(5; "Fecha original"; Date)
        {
        }
    }

    keys
    {
        key(Key1; Fecha)
        {
            Clustered = true;
        }
        key(Key2; Mes, "Dia Semana")
        {
        }
    }

    fieldgroups
    {
    }

    var
        SysDate: Record Date;
}

