table 76366 "Promotor - Ppto Vtas"
{
    DrillDownPageID = "Promotores - Ppto Vtas";
    LookupPageID = "Promotores - Ppto Vtas";

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
                if Item.Get("Cod. Producto") then
                    "Item Description" := Item.Description;

                Item.TestField("Nivel Escolar (Grado)");
                //Item.TESTFIELD("Nivel Educativo");
                Item.TestField("Grupo de Negocio");

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
        field(5; Quantity; Integer)
        {
            Caption = 'Quantity';
        }
        field(6; "Cantidad camp. anterior"; Integer)
        {
        }
        field(7; "Cod. producto equivalente"; Code[20])
        {
            TableRelation = Item;
        }
        field(8; Adopcion; Code[1])
        {
            ValuesAllowed = 'C', 'M', 'P', 'R';
        }
        field(9; "Adopcion anterior"; Code[1])
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
        Prom: Record "Salesperson/Purchaser";
        Item: Record Item;
        ProdEquivalente: Record "Productos Equivalentes";
}

