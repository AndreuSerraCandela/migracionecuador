table 76346 "Miembros cooperativa"
{
    DrillDownPageID = "Lista Miembros Cooperativa";
    LookupPageID = "Lista Miembros Cooperativa";

    fields
    {
        field(1; "Tipo de miembro"; Option)
        {
            Caption = 'Member type';
            DataClassification = ToBeClassified;
            OptionCaption = 'Member, Partner';
            OptionMembers = Miembro,Socio;
        }
        field(2; "Employee No."; Code[20])
        {
            Caption = 'Employee No.';
            DataClassification = ToBeClassified;
            NotBlank = true;
            TableRelation = Employee;

            trigger OnValidate()
            begin
                if Emp.Get("Employee No.") then
                    "Full name" := Emp."Full Name";
            end;
        }
        field(10; "1ra Quincena"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(11; "2da Quincena"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Fecha inactivacion"; Date)
        {
            Caption = 'Inactivation date';
            DataClassification = ToBeClassified;
        }
        field(23; "Full name"; Text[150])
        {
            Caption = 'Full name';
        }
        field(24; "Fecha inscripcion"; Date)
        {
            Caption = 'Enrollment date';
            DataClassification = ToBeClassified;
        }
        field(25; "Tipo de aporte"; Option)
        {
            Caption = 'Contribution type';
            DataClassification = ToBeClassified;
            OptionCaption = 'Fix,Percentage';
            OptionMembers = Fijo,Porcentual;
        }
        field(26; Importe; Decimal)
        {
            Caption = 'Amount';
            DataClassification = ToBeClassified;
        }
        field(27; "Ahorro acumulado"; Decimal)
        {
            CalcFormula = Sum ("Mov. cooperativa".Importe WHERE ("Employee No." = FIELD ("Employee No."),
                                                                "Tipo transaccion" = CONST (Aporte)));
            Caption = 'Accumulated savings';
            Editable = false;
            FieldClass = FlowField;
        }
        field(28; "Prestamos pendientes"; Integer)
        {
            CalcFormula = Count ("Mov. cooperativa" WHERE ("Employee No." = FIELD ("Employee No."),
                                                          "Tipo transaccion" = CONST ("Préstamo")));
            Caption = 'Outstanding loans';
            Editable = false;
            FieldClass = FlowField;
        }
        field(29; "Importe pendiente"; Decimal)
        {
            CalcFormula = Sum ("Mov. cooperativa".Importe WHERE ("Employee No." = FIELD ("Employee No."),
                                                                "Tipo transaccion" = CONST ("Préstamo")));
            Caption = 'Amount pending';
            Editable = false;
            FieldClass = FlowField;
        }
        field(30; Status; Option)
        {
            Caption = 'Status';
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Active,Inactive,Retired,Reinstated';
            OptionMembers = " ",Activo,Inactivo,Retirado;
        }
        field(31; "Fecha reingreso"; Date)
        {
            Caption = 'Re-entry date';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Employee No.")
        {
            Clustered = true;
        }
        key(Key2; "Full name")
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Employee No.", "Full name", "Tipo de miembro")
        {
        }
        fieldgroup(Brick; "Employee No.", "Full name", "Tipo de miembro")
        {
        }
    }

    var
        Emp: Record Employee;
}

