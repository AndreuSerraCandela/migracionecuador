table 64836 "Field Filter"
{

    fields
    {
        field(1; "Specification No."; Code[20])
        {
            TableRelation = Specification."No.";
        }
        field(2; Type; Option)
        {
            Editable = false;
            OptionMembers = "Source Filter","Dest. Filter";
            //This property is currently not supported
            //TestTableRelation = false;
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //ValidateTableRelation = false;
        }
        field(5; "Field No."; Integer)
        {

            trigger OnLookup()
            begin
                //fes mig
                /*
                Specification.GET("Specification No.");
                IF Type = Type::"Source Filter" THEN BEGIN
                  DbDesign := Specification."Source Design";
                  IF Specification."Transfer Type" = Specification."Transfer Type"::"By Actions" THEN
                    TableNo := Specification."Action Table No."
                  ELSE
                    TableNo := Specification."Source Table No";
                END ELSE BEGIN
                  DbDesign := Specification."Dest. Design";
                  TableNo := Specification."Dest. Table No.";
                END;
                
                IF DbDesign = '' THEN BEGIN
                  CLEAR(FieldForm);
                  Fields.SETRANGE(TableNo,TableNo);
                  FieldForm.SETRECORD(Fields);
                  FieldForm.SETTABLEVIEW(Fields);
                  FieldForm.LOOKUPMODE(TRUE);
                  IF FieldForm.RUNMODAL = ACTION::LookupOK THEN BEGIN
                    FieldForm.GETRECORD(Fields);
                    "Field No." := Fields."No.";
                    "Field Name" := Fields.FieldName;
                  END;
                END ELSE BEGIN
                  CLEAR(DBFieldForm);
                  DBFields.SETRANGE("Database Code",DbDesign);
                  DBFields.SETRANGE("Table No.",TableNo);
                  DBFieldForm.SETRECORD(DBFields);
                  DBFieldForm.SETTABLEVIEW(DBFields);
                  DBFieldForm.LOOKUPMODE(TRUE);
                  IF DBFieldForm.RUNMODAL = ACTION::LookupOK THEN BEGIN
                    DBFieldForm.GETRECORD(DBFields);
                    "Field No." := DBFields."Field No.";
                    "Field Name" := DBFields."Field Name";
                  END;
                END;
                */
                //fes mig

            end;

            trigger OnValidate()
            begin
                Specification.Get("Specification No.");
                if "Field No." <> 0 then begin
                    if Type = Type::"Source Filter" then begin
                        DbDesign := Specification."Source Design";
                        if Specification."Transfer Type" = Specification."Transfer Type"::"By Actions" then
                            TableNo := Specification."Action Table No."
                        else
                            TableNo := Specification."Source Table No";
                    end else begin
                        DbDesign := Specification."Dest. Design";
                        TableNo := Specification."Dest. Table No.";
                    end;
                    if DbDesign = '' then begin
                        Fields.Get(TableNo, "Field No.");
                        "Field Name" := Fields.FieldName;
                    end else begin
                        DBFields.Get(DbDesign, TableNo, "Field No.");
                        "Field Name" := DBFields."Field Name";
                    end;
                end else
                    "Field Name" := '';
            end;
        }
        field(6; "Field Name"; Text[30])
        {
            Editable = false;
            FieldClass = Normal;
        }
        field(7; "Filter"; Text[250])
        {

            trigger OnValidate()
            begin
                if StrPos(Filter, '%') <> 0 then
                    exit;

                Specification.Get("Specification No.");
                if Type = Type::"Source Filter" then begin
                    DbDesign := Specification."Source Design";
                    if Specification."Transfer Type" = Specification."Transfer Type"::"By Actions" then
                        TableNo := Specification."Action Table No."
                    else
                        TableNo := Specification."Source Table No";
                end else begin
                    DbDesign := Specification."Dest. Design";
                    TableNo := Specification."Dest. Table No.";
                end;

                if DbDesign = '' then begin
                    Fields.Get(TableNo, "Field No.");
                    case Fields.Type of
                        Fields.Type::OemText:
                            Specification.SetFilter(Text, Filter);
                        Fields.Type::OemCode:
                            begin
                                Filter := UpperCase(Filter);
                                Specification.SetFilter(Code, Filter);
                            end;
                        Fields.Type::Integer:
                            Specification.SetFilter(Integer, Filter);
                        Fields.Type::Decimal:
                            Specification.SetFilter(Decimal, Filter);
                        Fields.Type::Date:
                            begin
                                Specification.SetFilter(Date, Filter);
                                if Evaluate(Specification.Date, Filter) then
                                    Filter := Format(Specification.Date);
                            end;
                        Fields.Type::Time:
                            begin
                                Specification.SetFilter(Time, Filter);
                                if Evaluate(Specification.Time, Filter) then
                                    Filter := Format(Specification.Time);
                            end;
                        Fields.Type::Boolean:
                            begin
                                Specification.SetFilter(Boolean, Filter);
                                if ((Filter <> '0') and (Filter <> '1')) then begin
                                    if Evaluate(Specification.Boolean, Filter) then
                                        Filter := Format(Specification.Boolean);
                                end;
                            end;
                        Fields.Type::Option:
                            Specification.SetFilter(Option, Filter);
                    end;
                end else begin
                    DBFields.Get(DbDesign, TableNo, "Field No.");
                    case DBFields."Field Type" of
                        DBFields."Field Type"::Text:
                            Specification.SetFilter(Text, Filter);
                        DBFields."Field Type"::Code:
                            begin
                                Filter := UpperCase(Filter);
                                Specification.SetFilter(Code, Filter);
                            end;
                        DBFields."Field Type"::Integer:
                            Specification.SetFilter(Integer, Filter);
                        DBFields."Field Type"::Decimal:
                            Specification.SetFilter(Decimal, Filter);
                        DBFields."Field Type"::Date:
                            begin
                                Specification.SetFilter(Date, Filter);
                                if Evaluate(Specification.Date, Filter) then
                                    Filter := Format(Specification.Date);
                            end;
                        DBFields."Field Type"::Time:
                            begin
                                Specification.SetFilter(Time, Filter);
                                if Evaluate(Specification.Time, Filter) then
                                    Filter := Format(Specification.Time);
                            end;
                        DBFields."Field Type"::Boolean:
                            begin
                                Specification.SetFilter(Boolean, Filter);
                                if ((Filter <> '0') and (Filter <> '1')) then begin
                                    if Evaluate(Specification.Boolean, Filter) then
                                        Filter := Format(Specification.Boolean);
                                end;
                            end;
                        DBFields."Field Type"::Option:
                            Specification.SetFilter(Option, Filter);
                    end;
                end;
            end;
        }
    }

    keys
    {
        key(Key1; "Specification No.", Type, "Field No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        "Fields": Record "Field";
        DBFields: Record "Database Field";
        Specification: Record Specification;
        DbDesign: Code[20];
        TableNo: Integer;
}

