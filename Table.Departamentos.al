table 76035 Departamentos
{
    Caption = 'Department';
    DrillDownPageID = Departamentos;
    LookupPageID = Departamentos;

    fields
    {
        field(1; Codigo; Code[20])
        {
            Caption = 'Code';
        }
        field(2; Descripcion; Text[60])
        {
            Caption = 'Description';
        }
        field(3; "Total Empleados"; Integer)
        {
            CalcFormula = Count(Employee WHERE(Departamento = FIELD(Codigo)));
            Caption = 'Total Employees';
            Editable = false;
            FieldClass = FlowField;
        }
        field(4; Inactivo; Boolean)
        {
            Caption = 'Disabled';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin

                Emp.SetRange(Departamento, Codigo);
                if Emp.FindFirst then
                    Error(StrSubstNo(Err002, TableCaption, Codigo));
            end;
        }
    }

    keys
    {
        key(Key1; Codigo)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; Codigo, Descripcion)
        {
        }
    }

    trigger OnDelete()
    begin
        Emp.Reset;
        Emp.SetRange(Departamento, Codigo);
        if Emp.FindFirst then
            Error(StrSubstNo(Err001, TableCaption, Codigo));

        SubDepto.Reset;
        SubDepto.SetRange("Cod. Departamento", Codigo);
        if SubDepto.FindSet(true) then
            repeat
                SubDepto2.Get(SubDepto."Cod. Departamento", SubDepto.Codigo);
                SubDepto2.Delete(true);
            until SubDepto.Next = 0;
    end;

    var
        SubDepto: Record "Sub-Departamentos";
        SubDepto2: Record "Sub-Departamentos";
        Emp: Record Employee;
        Err001: Label 'You can not delete %1 %2 because there are employees associated to it';
        Err002: Label 'You can not block %1 %2 because there are employees associated to it';
}

