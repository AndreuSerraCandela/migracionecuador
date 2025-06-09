table 76088 "Parametros Loc. x País"
{
    Caption = 'Localization by Country setup';
    DrillDownPageId = "Parametros Loc. x Pais";
    LookupPageId = "Parametros Loc. x Pais";

    fields
    {
        field(1; "País"; Code[20])
        {
            Caption = 'Country';
            TableRelation = "Country/Region";
        }
        field(2; "NCF Activado"; Boolean)
        {
            Caption = 'NCF Activated';
        }
        field(3; "Control Lin. por Factura"; Boolean)
        {
            Caption = 'Control Lines per Invoice';
        }
        field(4; "Cantidad Lin. por factura"; Integer)
        {
            Caption = 'Line Qty. per Invoice';
        }
        field(5; "Re facturacion"; Boolean)
        {
            Caption = 'Re Invoicing';
        }
        field(6; "Caption Depto"; Text[30])
        {
        }
        field(7; "Caption Sub Depto"; Text[30])
        {
        }
        field(8; "Caption ISR"; Text[30])
        {
        }
        field(9; "Caption INFOTEP"; Text[30])
        {
        }
        field(10; "Caption AFP"; Text[30])
        {
        }
        field(11; "Caption SFS"; Text[30])
        {
        }
        field(12; "Caption SRL"; Text[30])
        {
        }
        field(13; "Formato Doc. Vtas. por cliente"; Boolean)
        {
            Caption = 'Sales documents format by customer';
        }
    }

    keys
    {
        key(Key1; "País")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "País")
        {
        }
    }

    var
        Err001: Label 'The percent total is higher than 100%';
}

