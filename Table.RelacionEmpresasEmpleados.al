table 76005 "Relacion Empresas Empleados"
{
    Caption = 'Company Tax Retention';

    fields
    {
        field(1; "Cod. Empleado"; Code[20])
        {
            TableRelation = Employee;
        }
        field(2; Empresa; Text[30])
        {
            Caption = 'Company';
            TableRelation = Company;

            trigger OnValidate()
            begin
                if xRec.Empresa <> Empresa then
                    "Cod. Empleado en empresa" := '';
            end;
        }
        field(3; "Cod. Empleado en empresa"; Code[20])
        {

            trigger OnLookup()
            var
                Empl: Record Employee;
                frmListaEmpl: Page "Employee List - Payroll";
            begin
                frmListaEmpl.ParamCompany(Empresa);
                frmListaEmpl.LookupMode(true);
                if frmListaEmpl.RunModal = ACTION::LookupOK then begin
                    frmListaEmpl.GetRecord(Empl);
                    Validate("Cod. Empleado en empresa", Empl."No.");
                    if "Cod. Empleado en empresa" <> xRec."Cod. Empleado en empresa" then
                        Modify(true);
                end;

                Clear(frmListaEmpl);
            end;
        }
    }

    keys
    {
        key(Key1; "Cod. Empleado", Empresa)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        RetImp: Record "Relacion Empresas Empleados";
        Err001: Label 'There can be only one company of retention';
}

