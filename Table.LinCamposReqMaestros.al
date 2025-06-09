table 76263 "Lin. Campos Req. Maestros"
{
    Caption = 'Required fields Line';

    fields
    {
        field(1; "No. Tabla"; Integer)
        {
            Caption = 'Table No.';
        }
        field(2; Nombre; Text[100])
        {
        }
        field(3; "No. Campo"; Integer)
        {
            Caption = 'Field No.';
            NotBlank = true;

            trigger OnLookup()
            begin
                Clear(FieldForm);
                Fields.SetRange(TableNo, "No. Tabla");
                FieldForm.SetRecord(Fields);
                FieldForm.SetTableView(Fields);
                FieldForm.LookupMode(true);
                if FieldForm.RunModal = ACTION::LookupOK then begin
                    FieldForm.GetRecord(Fields);
                    "No. Campo" := Fields."No.";
                    "Nombre Campo" := Fields."Field Caption";
                end;
            end;

            trigger OnValidate()
            begin
                "Nombre Campo" := '';
                if "No. Campo" <> 0 then begin
                    Fields.Get("No. Tabla", "No. Campo");
                    "Nombre Campo" := Fields."Field Caption";
                end;
            end;
        }
        field(4; "Nombre Campo"; Text[80])
        {
            Caption = 'Field Name';
        }
    }

    keys
    {
        key(Key1; "No. Tabla", "No. Campo")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        "Fields": Record "Field";
        FieldForm: Page Campos;
}

