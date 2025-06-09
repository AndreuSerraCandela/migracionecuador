table 56101 "Contratos Bck1"
{
    // #269159, 14.10.19, RRT: Esta tabla se ha creado para conservar los contratos que sean eliminados por los cambios realizados en #269159
    //          Los contratos que aparezcan en esta tabla se han eliminado por duplicidad detectada.


    fields
    {
        field(1; "Empresa cotización"; Code[10])
        {
        }
        field(2; "No. empleado"; Code[15])
        {
            TableRelation = Employee;
        }
        field(3; "No. Orden"; Integer)
        {
        }
        field(4; "Cód. contrato"; Code[5])
        {
            NotBlank = true;
            TableRelation = "Employment Contract";
        }
        field(5; Disponible; Code[12])
        {
            Enabled = false;
        }
        field(6; "Descripción"; Text[50])
        {
        }
        field(7; "Fecha inicio"; Date)
        {
        }
        field(8; "Duración"; Text[30])
        {
            DateFormula = true;
        }
        field(9; "Fecha finalización"; Date)
        {
        }
        field(10; Cargo; Code[15])
        {
            TableRelation = "Puestos laborales";
        }
        field(11; "Centro trabajo"; Code[10])
        {
        }
        field(12; "Motivo baja"; Code[10])
        {
            TableRelation = "Grounds for Termination";
        }
        field(21; Finalizado; Boolean)
        {
        }
        field(22; "Días preaviso"; Text[30])
        {
            DateFormula = true;
            InitValue = '15D';
        }
        field(23; "Período prueba"; Text[30])
        {
            DateFormula = true;
        }
        field(33; Jornada; Text[20])
        {
        }
        field(34; "Tipo Pago Nomina"; Option)
        {
            Caption = 'Payroll payment type';
            OptionCaption = 'Daily,Weekly,Bi-Weekly,Half Month,Monthly,Yearly';
            OptionMembers = Diaria,Semanal,"Bi-Semanal",Quincenal,Mensual,Anual;
        }
        field(39; "Días semana"; Decimal)
        {
            DecimalPlaces = 2 : 2;
        }
        field(40; "Horas dia"; Decimal)
        {
            DecimalPlaces = 2 : 2;
        }
        field(41; "Horas semana"; Decimal)
        {
            DecimalPlaces = 2 : 2;
        }
        field(50; "Causa de la Baja"; Text[30])
        {
        }
        field(61; Indefinido; Boolean)
        {
        }
        field(62; Activo; Boolean)
        {
        }
        field(63; "Grado ocupacion"; Decimal)
        {
            Caption = 'Grado ocupación';
            Description = 'MdE';
            MaxValue = 100;
            MinValue = 0;
        }
        field(50000; "Fecha eliminación"; Date)
        {
        }
        field(50001; "Usuario eliminación"; Code[50])
        {
        }
    }

    keys
    {
        key(Key1; "No. empleado", "No. Orden")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        Contratos: Record Contratos;
    begin
    end;
}

