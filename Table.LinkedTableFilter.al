table 64837 "Linked Table Filter"
{

    fields
    {
        field(1; "Specification No."; Code[20])
        {
            Editable = false;
            TableRelation = Specification."No.";
        }
        field(4; Type; Option)
        {
            OptionMembers = CONSTANT,"FIELD";

            trigger OnValidate()
            begin
                if Type = Type::CONSTANT then
                    "Main Table Field No." := 0;
            end;
        }
        field(5; "Linked Field No."; Integer)
        {

            trigger OnLookup()
            begin
                //fes mig
                /*
                Specification.GET("Specification No.");
                
                IF Specification."Source Design" = '' THEN BEGIN
                  CLEAR(TableFieldForm);
                  Fields.SETRANGE(TableNo,Specification."Source Table No");
                  TableFieldForm.SETRECORD(Fields);
                  TableFieldForm.SETTABLEVIEW(Fields);
                  TableFieldForm.LOOKUPMODE(TRUE);
                  IF TableFieldForm.RUNMODAL = ACTION::LookupOK THEN BEGIN
                    TableFieldForm.GETRECORD(Fields);
                    "Linked Field No." := Fields."No.";
                    "Linked Field Name" := Fields.FieldName;
                  END;
                END ELSE BEGIN
                  CLEAR(DbFieldForm);
                  DbFields.SETRANGE("Database Code",Specification."Source Design");
                  DbFields.SETRANGE("Table No.",Specification."Source Table No");
                  DbFieldForm.SETRECORD(DbFields);
                  DbFieldForm.SETTABLEVIEW(DbFields);
                  DbFieldForm.LOOKUPMODE(TRUE);
                  IF DbFieldForm.RUNMODAL = ACTION::LookupOK THEN BEGIN
                    DbFieldForm.GETRECORD(DbFields);
                    "Linked Field No." := DbFields."Field No.";
                    "Linked Field Name" := DbFields."Field Name";
                  END;
                END;
                */
                //fes mig

            end;

            trigger OnValidate()
            begin
                Specification.Get("Specification No.");
                if "Linked Field No." <> 0 then begin
                    if Specification."Source Design" = '' then begin
                        Fields.Get(Specification."Source Table No", "Linked Field No.");
                        "Linked Field Name" := Fields.FieldName;
                    end else begin
                        DbFields.Get(Specification."Source Design", Specification."Source Table No", "Linked Field No.");
                        "Linked Field Name" := DbFields."Field Name";
                    end;
                end else
                    "Linked Field Name" := '';
            end;
        }
        field(6; "Linked Field Name"; Text[30])
        {
            Editable = false;
            FieldClass = Normal;
        }
        field(7; "Main Table Field No."; Integer)
        {

            trigger OnLookup()
            begin
                //fes mig
                /*
                Specification.GET("Specification No.");
                MainSpecification.GET(Specification."Main Spec.");
                IF MainSpecification."Source Design" = '' THEN BEGIN
                  CLEAR(TableFieldForm);
                  Fields.SETRANGE(TableNo,MainSpecification."Source Table No");
                  TableFieldForm.SETRECORD(Fields);
                  TableFieldForm.SETTABLEVIEW(Fields);
                  TableFieldForm.LOOKUPMODE(TRUE);
                  IF TableFieldForm.RUNMODAL = ACTION::LookupOK THEN BEGIN
                    TableFieldForm.GETRECORD(Fields);
                    "Main Table Field No." := Fields."No.";
                    Value := Fields.FieldName;
                  END;
                END ELSE BEGIN
                  CLEAR(DbFieldForm);
                  DbFields.SETRANGE("Database Code",MainSpecification."Source Design");
                  DbFields.SETRANGE("Table No.",MainSpecification."Source Table No");
                  DbFieldForm.SETRECORD(DbFields);
                  DbFieldForm.SETTABLEVIEW(DbFields);
                  DbFieldForm.LOOKUPMODE(TRUE);
                  IF DbFieldForm.RUNMODAL = ACTION::LookupOK THEN BEGIN
                    DbFieldForm.GETRECORD(DbFields);
                    "Main Table Field No." := DbFields."Field No.";
                    Value := DbFields."Field Name";
                  END;
                END;
                */

            end;

            trigger OnValidate()
            begin
                Specification.Get("Specification No.");
                MainSpecification.Get(Specification."Main Spec.");
                if "Main Table Field No." <> 0 then begin
                    if MainSpecification."Source Design" = '' then begin
                        Fields.Get(MainSpecification."Source Table No", "Main Table Field No.");
                        Value := Fields.FieldName;
                    end else begin
                        DbFields.Get(MainSpecification."Source Design", MainSpecification."Source Table No", "Main Table Field No.");
                        Value := DbFields."Field Name";
                    end;
                end else
                    Value := '';
            end;
        }
        field(8; Value; Text[100])
        {
            FieldClass = Normal;

            trigger OnLookup()
            begin
                //fes mig
                /*
                Specification.GET("Specification No.");
                MainSpecification.GET(Specification."Main Spec.");
                IF Type = Type::FIELD THEN BEGIN
                  IF MainSpecification."Source Design" = '' THEN BEGIN
                    CLEAR(TableFieldForm);
                    Fields.SETRANGE(TableNo,MainSpecification."Source Table No");
                    TableFieldForm.SETRECORD(Fields);
                    TableFieldForm.SETTABLEVIEW(Fields);
                    TableFieldForm.LOOKUPMODE(TRUE);
                    IF TableFieldForm.RUNMODAL = ACTION::LookupOK THEN BEGIN
                      TableFieldForm.GETRECORD(Fields);
                      "Main Table Field No." := Fields."No.";
                      Value := Fields.FieldName;
                    END;
                  END ELSE BEGIN
                    CLEAR(DbFieldForm);
                    DbFields.SETRANGE("Database Code",MainSpecification."Source Design");
                    DbFields.SETRANGE("Table No.",MainSpecification."Source Table No");
                    DbFieldForm.SETRECORD(DbFields);
                    DbFieldForm.SETTABLEVIEW(DbFields);
                    DbFieldForm.LOOKUPMODE(TRUE);
                    IF DbFieldForm.RUNMODAL = ACTION::LookupOK THEN BEGIN
                      DbFieldForm.GETRECORD(DbFields);
                      "Main Table Field No." := DbFields."Field No.";
                      Value := DbFields."Field Name";
                    END;
                  END;
                END;
                */
                //fes mig

            end;

            trigger OnValidate()
            begin
                Specification.Get("Specification No.");
                MainSpecification.Get(Specification."Main Spec.");
                if Type = Type::CONSTANT then begin
                    if Specification."Source Design" = '' then begin
                        Fields.Get(Specification."Source Table No", "Linked Field No.");
                        case Fields.Type of
                            Fields.Type::OemText:
                                Specification.SetFilter(Text, Value);
                            Fields.Type::OemCode:
                                begin
                                    Value := UpperCase(Value);
                                    Specification.SetFilter(Code, Value);
                                end;
                            Fields.Type::Integer:
                                Specification.SetFilter(Integer, Value);
                            Fields.Type::Decimal:
                                Specification.SetFilter(Decimal, Value);
                            Fields.Type::Date:
                                begin
                                    Specification.SetFilter(Date, Value);
                                    if Evaluate(Specification.Date, Value) then
                                        Value := Format(Specification.Date);
                                end;
                            Fields.Type::Time:
                                begin
                                    Specification.SetFilter(Time, Value);
                                    if Evaluate(Specification.Time, Value) then
                                        Value := Format(Specification.Time);
                                end;
                            Fields.Type::Boolean:
                                begin
                                    Specification.SetFilter(Boolean, Value);
                                    if ((Value <> '0') and (Value <> '1')) then begin
                                        if Evaluate(Specification.Boolean, Value) then
                                            Value := Format(Specification.Boolean);
                                    end;
                                end;
                            Fields.Type::Option:
                                Specification.SetFilter(Option, Value);
                        end;
                    end else begin
                        DbFields.Get(Specification."Source Design", Specification."Source Table No", "Linked Field No.");
                        case DbFields."Field Type" of
                            DbFields."Field Type"::Text:
                                Specification.SetFilter(Text, Value);
                            DbFields."Field Type"::Code:
                                begin
                                    Value := UpperCase(Value);
                                    Specification.SetFilter(Code, Value);
                                end;
                            DbFields."Field Type"::Integer:
                                Specification.SetFilter(Integer, Value);
                            DbFields."Field Type"::Decimal:
                                Specification.SetFilter(Decimal, Value);
                            DbFields."Field Type"::Date:
                                begin
                                    Specification.SetFilter(Date, Value);
                                    if Evaluate(Specification.Date, Value) then
                                        Value := Format(Specification.Date);
                                end;
                            DbFields."Field Type"::Time:
                                begin
                                    Specification.SetFilter(Time, Value);
                                    if Evaluate(Specification.Time, Value) then
                                        Value := Format(Specification.Time);
                                end;
                            DbFields."Field Type"::Boolean:
                                begin
                                    Specification.SetFilter(Boolean, Value);
                                    if ((Value <> '0') and (Value <> '1')) then begin
                                        if Evaluate(Specification.Boolean, Value) then
                                            Value := Format(Specification.Boolean);
                                    end;
                                end;
                            DbFields."Field Type"::Option:
                                Specification.SetFilter(Option, Value);
                        end;
                    end;
                end else begin
                    if Evaluate(xInteger, Value) then begin
                        if Value <> '0' then begin
                            if MainSpecification."Source Design" = '' then begin
                                Fields.Get(MainSpecification."Source Table No", xInteger);
                                Value := Fields.FieldName;
                            end else begin
                                DbFields.Get(MainSpecification."Source Design", MainSpecification."Source Table No", xInteger);
                                Value := DbFields."Field Name";
                            end;
                            "Main Table Field No." := xInteger;
                        end else
                            Value := '';
                    end else begin
                        if MainSpecification."Source Design" = '' then begin
                            Fields.SetRange(TableNo, MainSpecification."Source Table No");
                            Fields.SetRange(FieldName, Value);
                            Fields.Find('-');
                            "Main Table Field No." := Fields."No.";
                            Value := Fields.FieldName;
                        end else begin
                            DbFields.SetRange("Database Code", MainSpecification."Source Design");
                            DbFields.SetRange("Table No.", MainSpecification."Source Table No");
                            DbFields.SetRange("Field Name", Value);
                            DbFields.Find('-');
                            "Main Table Field No." := DbFields."Field No.";
                            Value := DbFields."Field Name";
                        end;
                    end;
                end;
            end;
        }
    }

    keys
    {
        key(Key1; "Specification No.", "Linked Field No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        DbFields: Record "Database Field";
        "Fields": Record "Field";
        Specification: Record Specification;
        MainSpecification: Record Specification;
        xInteger: Integer;
}

