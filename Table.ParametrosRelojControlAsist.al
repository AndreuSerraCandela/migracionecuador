table 76327 "Parametros Reloj Control Asist"
{
    Caption = 'Time and attendance clock setup';

    fields
    {
        field(1; "Clock ID"; Code[20])
        {
        }
        field(2; Description; Text[60])
        {
        }
        field(3; Provider; Text[100])
        {
            Description = 'Parametros conexion BD SQL externa';
        }
        field(4; "Data Source"; Text[100])
        {
            Description = 'Parametros conexion BD SQL externa';
        }
        field(5; "Initial Catalog"; Text[100])
        {
            Description = 'Parametros conexion BD SQL externa';
        }
        field(6; User; Text[100])
        {
            Description = 'Parametros conexion BD SQL externa';
        }
        field(7; Password; Text[100])
        {
            Description = 'Parametros conexion BD SQL externa';
        }
        field(8; "ID Campo Cod. Empleado"; Integer)
        {
            Caption = 'Field ID for Empl. code';
        }
        field(9; "ID Campo Cod. tarjeta"; Integer)
        {
            Caption = 'Field ID for Tag code';
        }
        field(10; "ID Campo Fecha registro"; Integer)
        {
            Caption = 'Field ID for Posting date';
        }
        field(11; "ID Campo Hora registro"; Integer)
        {
            Caption = 'Field ID for Posting time';
        }
        field(12; "ID Campo ID Equipo"; Code[3])
        {
            Caption = 'Field ID for Clock ID';
        }
        field(13; "Nombre tabla ponchador"; Text[30])
        {
            Caption = 'T&A table name';
        }
        field(14; "Nombre campo filtro de fecha"; Text[30])
        {
            Caption = 'Date filter name';
        }
    }

    keys
    {
        key(Key1; "Clock ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

