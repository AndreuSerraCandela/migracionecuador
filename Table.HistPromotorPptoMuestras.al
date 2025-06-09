table 76109 "Hist. Promotor - Ppto Muestras"
{

    fields
    {
        field(1; "Cod. Promotor"; Code[20])
        {
            TableRelation = "Salesperson/Purchaser" WHERE (Tipo = CONST (Vendedor));

            trigger OnValidate()
            begin
                if Prom.Get("Cod. Promotor") then
                    "Nombre Promotor" := Prom.Name;
            end;
        }
        field(2; "Cod. Producto"; Code[20])
        {
            TableRelation = Item;

            trigger OnValidate()
            begin
                if "Cod. Producto" <> '' then begin
                    Item.Get("Cod. Producto");
                    "Item Description" := Item.Description;
                end;

                if ProdEquivalente.Get("Cod. Producto") then
                    "Cod. producto equivalente" := ProdEquivalente."Cod. Producto Anterior";
            end;
        }
        field(3; "Nombre Promotor"; Text[60])
        {
        }
        field(4; "Item Description"; Text[60])
        {
            Caption = 'Item Description';
        }
        field(5; Quantity; Decimal)
        {
            Caption = 'Quantity';
        }
        field(6; "Extended Quantity"; Decimal)
        {
        }
        field(7; "Cantidad camp. anterior"; Decimal)
        {
        }
        field(8; "Cod. producto equivalente"; Code[20])
        {
        }
        field(9; Ano; Code[4])
        {
            Caption = 'Year';
            Numeric = true;
        }
    }

    keys
    {
        key(Key1; Ano, "Cod. Promotor", "Cod. Producto")
        {
            Clustered = true;
            SumIndexFields = Quantity;
        }
    }

    fieldgroups
    {
    }

    var
        Item: Record Item;
        Prom: Record "Salesperson/Purchaser";
        ProdEquivalente: Record "Productos Equivalentes";
}

