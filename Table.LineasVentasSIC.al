table 50113 "Lineas Ventas SIC"
{

    fields
    {
        field(1; "Tipo documento"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(2; "No. documento"; Code[40])
        {
            DataClassification = ToBeClassified;
        }
        field(3; "No. linea"; Integer)
        {
            DataClassification = ToBeClassified;
        }
        field(4; "Cod. Cliente"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(5; Fecha; Date)
        {
            DataClassification = ToBeClassified;
        }
        field(6; "Cod. Moneda"; Code[10])
        {
            DataClassification = ToBeClassified;
        }
        field(7; Cantidad; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(8; "Importe descuento"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(9; "Precio de venta"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(10; "Unidad de medida"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(11; Importe; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(12; "Importe ITBIS Incluido"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(13; codproducto; Text[50])
        {
            DataClassification = ToBeClassified;
            Enabled = true;
        }
        field(14; Transferido; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(15; ITBIS; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(16; "Location Code"; Code[40])
        {
            DataClassification = ToBeClassified;
            TableRelation = Location;
        }
        field(17; Origen; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Punto de Venta,From Hotel';
            OptionMembers = " ","Punto de Venta","From Hotel";
        }
        field(18; Cupon; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(19; "No. documento SIC"; Code[40])
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Tipo documento", "No. documento", "No. linea", "Location Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        /*
        LineasVtasICG.RESET;
        IF LineasVtasICG.FINDLAST THEN
          Id := LineasVtasICG.Id + 1
        ELSE
          Id := 1;
        */

    end;
}

