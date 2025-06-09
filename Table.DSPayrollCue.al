table 76403 "DSPayroll Cue"
{
    Caption = 'NOMDS Cue';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            DataClassification = ToBeClassified;
        }
        field(2; Loans; Integer)
        {
            CalcFormula = Count ("Histórico Cab. Préstamo" WHERE (Pendiente = CONST (true)));
            Caption = 'Pending Loans';
            Editable = false;
            FieldClass = FlowField;
        }
        field(3; "Active Employees"; Integer)
        {
            CalcFormula = Count (Employee WHERE (Status = CONST (Active)));
            Caption = 'Active Employees';
            Editable = false;
            FieldClass = FlowField;
        }
        field(4; "Active Contracts"; Integer)
        {
            CalcFormula = Count (Contratos WHERE (Activo = CONST (true)));
            Caption = 'Active contracts';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5; "Inactives Employees"; Integer)
        {
            CalcFormula = Count (Employee WHERE (Status = FILTER (Inactive | Terminated)));
            Caption = 'Inactive Employees';
            Editable = false;
            FieldClass = FlowField;
        }
        field(6; "Employees with wire transfer"; Integer)
        {
            CalcFormula = Count (Employee WHERE ("Forma de Cobro" = CONST ("Transferencia Banc."),
                                                "Calcular Nomina" = CONST (true)));
            Caption = 'Employees with wire transfer';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7; "Employees with check"; Integer)
        {
            CalcFormula = Count (Employee WHERE ("Forma de Cobro" = CONST (Cheque)));
            Caption = 'Employees with check';
            Editable = false;
            FieldClass = FlowField;
        }
        field(8; "Female Employees"; Integer)
        {
            CalcFormula = Count (Employee WHERE (Gender = CONST (Female),
                                                Status = CONST (Active)));
            Caption = 'Female Employees';
            FieldClass = FlowField;
        }
        field(9; "Male Employees"; Integer)
        {
            CalcFormula = Count (Employee WHERE (Gender = CONST (Male),
                                                Status = CONST (Active)));
            Caption = 'Male Employees';
            FieldClass = FlowField;
        }
        field(10; "New hires"; Integer)
        {
            CalcFormula = Count (Employee WHERE ("Employment Date" = FIELD ("Date Filter"),
                                                Status = CONST (Active)));
            Caption = 'New hires';
            FieldClass = FlowField;
        }
        field(11; "Employee departures"; Integer)
        {
            CalcFormula = Count (Employee WHERE ("Termination Date" = FIELD ("Date Filter"),
                                                Status = CONST (Inactive)));
            Caption = 'Employee departures';
            FieldClass = FlowField;
        }
        field(12; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;

            trigger OnValidate()
            begin
                SetRange("Birth Month filter", Date2DMY(GetRangeMax("Date Filter"), 2));
            end;
        }
        field(13; "Birthday of the month"; Integer)
        {
            CalcFormula = Count (Employee WHERE ("Mes Nacimiento" = FIELD ("Birth Month filter"),
                                                Status = CONST (Active)));
            Caption = 'Birthday of the month';
            FieldClass = FlowField;

            trigger OnLookup()
            var
                Emp: Record Employee;
            begin
            end;
        }
        field(14; "Birth Month filter"; Integer)
        {
            Caption = 'Birth Month filter';
            FieldClass = FlowFilter;
        }
        field(15; "Vacation to expire"; Integer)
        {
            Caption = 'Vacation to expire';
            DataClassification = ToBeClassified;
        }
        field(16; "Contract to expire"; Integer)
        {
            CalcFormula = Count (Contratos WHERE ("Fecha finalización" = FIELD (FILTER ("Date Filter")),
                                                 Activo = CONST (true)));
            Caption = 'Contract to expire';
            FieldClass = FlowField;
        }
        field(17; "Vacation to start"; Integer)
        {
            CalcFormula = Count ("Planificacion de vacaciones" WHERE ("Fecha inicio planificada" = FIELD ("Date Filter")));
            Caption = 'Vacation to take';
            FieldClass = FlowField;
        }
        field(18; "Vacation to finish"; Integer)
        {
            CalcFormula = Count ("Planificacion de vacaciones" WHERE ("Fecha fin planificada" = FIELD ("Date Filter")));
            Caption = 'Vacation to end';
            FieldClass = FlowField;
        }
        field(19; "Afiliados cooperativa"; Integer)
        {
            CalcFormula = Count ("Miembros cooperativa");
            Caption = 'Cooperative members';
            FieldClass = FlowField;
        }
        field(20; "Miembros activos"; Integer)
        {
            CalcFormula = Count ("Miembros cooperativa" WHERE (Status = CONST (Activo)));
            Caption = 'Active members';
            FieldClass = FlowField;
        }
        field(21; "Miembros inactivos"; Integer)
        {
            CalcFormula = Count ("Miembros cooperativa" WHERE (Status = CONST (" ")));
            Caption = 'Inactive members';
            FieldClass = FlowField;
        }
        field(22; "Prestamos activos"; Integer)
        {
            CalcFormula = Count ("Hist. Cab. Prest. cooperativa" WHERE (Status = FILTER (<> Completado)));
            Caption = 'Open loans';
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

