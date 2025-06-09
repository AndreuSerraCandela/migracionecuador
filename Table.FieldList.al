table 64825 "Field List"
{

    fields
    {
        field(1; "Specification No."; Code[20])
        {
            TableRelation = Specification."No.";
        }
        field(2; "List Type"; Option)
        {
            OptionMembers = "Field Transfer List","Key Field Links";
        }
        field(10; "Field No. Source"; Integer)
        {
            NotBlank = true;

            trigger OnLookup()
            begin
                /*Specification.GET("Specification No.");
                IF Specification."Source Design" = '' THEN BEGIN
                  CLEAR(FieldForm);
                  Fields.SETRANGE(TableNo,Specification."Source Table No");
                  FieldForm.SETRECORD(Fields);
                  FieldForm.SETTABLEVIEW(Fields);
                  FieldForm.LOOKUPMODE(TRUE);
                  IF FieldForm.RUNMODAL = ACTION::LookupOK THEN BEGIN
                    FieldForm.GETRECORD(Fields);
                    "Field No. Source" := Fields."No.";
                    "Field Name Source" := Fields.FieldName;
                  END;
                END ELSE BEGIN
                  CLEAR(DBFieldForm);
                  DBFields.SETRANGE("Database Code",Specification."Source Design");
                  DBFields.SETRANGE("Table No.",Specification."Source Table No");
                  DBFieldForm.SETRECORD(DBFields);
                  DBFieldForm.SETTABLEVIEW(DBFields);
                  DBFieldForm.LOOKUPMODE(TRUE);
                  IF DBFieldForm.RUNMODAL = ACTION::LookupOK THEN BEGIN
                    DBFieldForm.GETRECORD(DBFields);
                    "Field No. Source" := DBFields."Field No.";
                    "Field Name Source" := DBFields."Field Name";
                  END;
                END;*/ //fes mig

            end;

            trigger OnValidate()
            begin
                Specification.Get("Specification No.");

                if "Field No. Source" <> 0 then begin
                    if Specification."Source Design" = '' then begin
                        Fields.Get(Specification."Source Table No", "Field No. Source");
                        "Field Name Source" := Fields.FieldName;
                    end else begin
                        DBFields.Get(Specification."Source Design", Specification."Source Table No", "Field No. Source");
                        "Field Name Source" := DBFields."Field Name";
                    end;
                end else
                    "Field Name Source" := '';
            end;
        }
        field(11; "Field Name Source"; Text[30])
        {
            Editable = false;
        }
        field(20; "Field No. Dest."; Integer)
        {

            trigger OnLookup()
            begin
                /*Specification.GET("Specification No.");
                IF Specification."Dest. Design" = '' THEN BEGIN
                  CLEAR(FieldForm);
                  Fields.SETRANGE(TableNo,Specification."Dest. Table No.");
                  FieldForm.SETRECORD(Fields);
                  FieldForm.SETTABLEVIEW(Fields);
                  FieldForm.LOOKUPMODE(TRUE);
                  IF FieldForm.RUNMODAL = ACTION::LookupOK THEN BEGIN
                    FieldForm.GETRECORD(Fields);
                    "Field No. Dest." := Fields."No.";
                    "Field Name Dest." := Fields.FieldName;
                  END;
                END ELSE BEGIN
                  CLEAR(DBFieldForm);
                  DBFields.SETRANGE("Database Code",Specification."Dest. Design");
                  DBFields.SETRANGE("Table No.",Specification."Dest. Table No.");
                  DBFieldForm.SETRECORD(DBFields);
                  DBFieldForm.SETTABLEVIEW(DBFields);
                  DBFieldForm.LOOKUPMODE(TRUE);
                  IF DBFieldForm.RUNMODAL = ACTION::LookupOK THEN BEGIN
                    DBFieldForm.GETRECORD(DBFields);
                    "Field No. Dest." := DBFields."Field No.";
                    "Field Name Dest." := DBFields."Field Name";
                  END;
                END;*/ //fes mig

            end;

            trigger OnValidate()
            begin
                Specification.Get("Specification No.");

                if "Field No. Dest." <> 0 then begin
                    if Specification."Dest. Design" = '' then begin
                        Fields.Get(Specification."Dest. Table No.", "Field No. Dest.");
                        "Field Name Dest." := Fields.FieldName;
                    end else begin
                        DBFields.Get(Specification."Dest. Design", Specification."Dest. Table No.", "Field No. Dest.");
                        "Field Name Dest." := DBFields."Field Name";
                    end;
                end else
                    "Field Name Dest." := '';
            end;
        }
        field(21; "Field Name Dest."; Text[30])
        {
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Specification No.", "List Type", "Field No. Source")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        Specification.Get("Specification No.");
        if "List Type" = "List Type"::"Field Transfer List" then
            if (Specification."Field List Type" = Specification."Field List Type"::"All Fields") or
               (Specification."Field List Type" = Specification."Field List Type"::"Include List")
            then begin
                Specification."Field List Type" := Specification."Field List Type"::"Include List";
                Specification.Modify();
            end;
    end;

    var
        Specification: Record Specification;
        "Fields": Record "Field";
        DBFields: Record "Database Field";
}

