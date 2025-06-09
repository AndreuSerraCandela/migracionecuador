table 82506 "MIG Menu ventas TPV"
{
    Caption = 'Sales POS menu';
    LookupPageID = "SubLista - Botones Menu TPV";

    fields
    {
        field(1; "Menu ID"; Code[10])
        {
            Caption = 'ID Menu';
            NotBlank = true;
        }
        field(2; Columnas; Integer)
        {
            Caption = 'Columnas';
        }
        field(3; Filas; Integer)
        {
            Caption = 'Rows';
        }
        field(4; Descripcion; Text[250])
        {
            Caption = 'Description';
        }
        field(5; "Cantidad de botones"; Integer)
        {
            //CalcFormula = Count ("Grupos Cajeros" WHERE (Field3 = FIELD ("Menu ID")));
            Caption = 'Quantity of buttons';
            //FieldClass = FlowField;
        }
        field(6; "Menu pagos"; Boolean)
        {
            Caption = 'Tender Menu';
        }
        field(7; "Sub-Menu ID"; Option)
        {
            OptionCaption = ',1,2,3,4';
            OptionMembers = ,"1","2","3","4";
        }
    }

    keys
    {
        key(Key1; "Menu ID")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        rRec: RecordRef;
}

