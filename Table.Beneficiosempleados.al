table 76257 "Beneficios empleados"
{
    Caption = 'Employee benefits';

    fields
    {
        field(1; "Cod. Empleado"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Employee;
        }
        field(2; "Tipo Beneficio"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = 'Income,Others';
            OptionMembers = Ingresos,Otro;
        }
        field(3; Codigo; Code[16])
        {
            Caption = 'Code';
            TableRelation = "Datos adicionales RRHH".Code WHERE ("Tipo registro" = CONST (Beneficio));

            trigger OnLookup()
            begin
                Datosadic.Reset;
                Datosadic.SetRange("Tipo registro", Datosadic."Tipo registro"::Beneficio);
                if PAGE.RunModal(0, Datosadic) = ACTION::LookupOK then
                    Validate(Codigo, Datosadic.Code);
            end;

            trigger OnValidate()
            begin
                Datosadic.Get(0, Codigo);
                Descripcion := Datosadic.Descripcion;
            end;
        }
        field(4; Descripcion; Text[60])
        {
            Caption = 'Description';
        }
        field(5; Importe; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Cod. Empleado", "Tipo Beneficio", Codigo)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Cod. Empleado", "Tipo Beneficio")
        {
        }
    }

    var
        Datosadicionales: Page "Datos adicionales";
        Datosadic: Record "Datos adicionales RRHH";
}

