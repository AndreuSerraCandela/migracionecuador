table 76365 "Promotor - Ppto Muestras"
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
        field(4; "Item Description"; Text[100])
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
            CalcFormula = Sum ("Hist. Promotor - Ppto Muestras".Quantity WHERE ("Cod. Promotor" = FIELD ("Cod. Promotor"),
                                                                               "Cod. Producto" = FIELD ("Cod. producto equivalente")));
            Caption = 'Qty. Last Campaign';
            Editable = false;
            FieldClass = FlowField;
        }
        field(8; "Cod. producto equivalente"; Code[20])
        {
            TableRelation = Item;
        }
        field(9; "Cantidad consumida"; Decimal)
        {
            CalcFormula = Sum ("Promotor - Entrega Muestras".Cantidad WHERE ("Cod. Promotor" = FIELD ("Cod. Promotor"),
                                                                            "Cod. Producto" = FIELD ("Cod. Producto")));
            FieldClass = FlowField;
        }
        field(10; "Cantidad seleccionada"; Decimal)
        {
        }
        field(11; "No. documento"; Code[20])
        {
        }
    }

    keys
    {
        key(Key1; "Cod. Promotor", "Cod. Producto")
        {
            Clustered = true;
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

