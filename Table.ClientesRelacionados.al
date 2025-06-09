table 76422 "Clientes Relacionados"
{
    Caption = 'Related Customers';
    DrillDownPageID = Turnos;
    LookupPageID = Turnos;

    fields
    {
        field(1; "Cod. Cliente"; Code[20])
        {
            Caption = 'Customer code';
            TableRelation = Customer;

            trigger OnValidate()
            begin
                if "Cod. Cliente" <> '' then begin
                    Cust.Get("Cod. Cliente");
                    Descripcion := Cust.Name;
                end;
            end;
        }
        field(2; "Cod. Cliente Relacionado"; Code[20])
        {
            Caption = 'Related Customer code';
            TableRelation = Customer;

            trigger OnValidate()
            begin
                if "Cod. Cliente Relacionado" <> '' then begin
                    Cust.Get("Cod. Cliente Relacionado");
                    "Descripcion Cte. Relacionado" := Cust.Name;
                end;
            end;
        }
        field(3; Descripcion; Text[100])
        {
            Caption = 'Description';
            Description = '#56924';
        }
        field(4; "Descripcion Cte. Relacionado"; Text[100])
        {
            Caption = 'Related Cust. Description';
        }
        field(5; Balance; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum ("Detailed Cust. Ledg. Entry".Amount WHERE ("Customer No." = FIELD ("Cod. Cliente Relacionado"),
                                                                         "Initial Entry Global Dim. 1" = FIELD ("Global Dimension 1 Filter"),
                                                                         "Initial Entry Global Dim. 2" = FIELD ("Global Dimension 2 Filter"),
                                                                         "Currency Code" = FIELD ("Currency Filter"),
                                                                         "Posting Date" = FIELD ("Date Filter")));
            Caption = 'Balance';
            Editable = false;
            FieldClass = FlowField;
        }
        field(6; "Balance (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum ("Detailed Cust. Ledg. Entry"."Amount (LCY)" WHERE ("Customer No." = FIELD ("Cod. Cliente Relacionado"),
                                                                                 "Initial Entry Global Dim. 1" = FIELD ("Global Dimension 1 Filter"),
                                                                                 "Initial Entry Global Dim. 2" = FIELD ("Global Dimension 2 Filter"),
                                                                                 "Currency Code" = FIELD ("Currency Filter"),
                                                                                 "Posting Date" = FIELD ("Date Filter")));
            Caption = 'Balance ($)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No." = CONST (1));
        }
        field(8; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No." = CONST (2));
        }
        field(9; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(10; "Global Dimension 1 Filter"; Code[20])
        {
            CaptionClass = '1,3,1';
            Caption = 'Global Dimension 1 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No." = CONST (1));
        }
        field(11; "Global Dimension 2 Filter"; Code[20])
        {
            CaptionClass = '1,3,2';
            Caption = 'Global Dimension 2 Filter';
            FieldClass = FlowFilter;
            TableRelation = "Dimension Value".Code WHERE ("Global Dimension No." = CONST (2));
        }
        field(12; "Currency Filter"; Code[10])
        {
            Caption = 'Currency Filter';
            FieldClass = FlowFilter;
            TableRelation = Currency;
        }
    }

    keys
    {
        key(Key1; "Cod. Cliente", "Cod. Cliente Relacionado")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        Cust: Record Customer;
}

