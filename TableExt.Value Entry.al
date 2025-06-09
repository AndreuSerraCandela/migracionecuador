tableextension 50124 tableextension50124 extends "Value Entry"
{
    fields
    {
        modify("Item Ledger Entry Type")
        {
            Caption = 'Item Ledger Entry Type';
        }

        //Unsupported feature: Property Modification (Data type) on "Description(Field 7)".

        modify("Global Dimension 1 Code")
        {
            Caption = 'Global Dimension 1 Code';
        }
        modify("Global Dimension 2 Code")
        {
            Caption = 'Global Dimension 2 Code';
        }
        modify("Gen. Bus. Posting Group")
        {
            Caption = 'Gen. Bus. Posting Group';
        }
        modify("Gen. Prod. Posting Group")
        {
            Caption = 'Gen. Prod. Posting Group';
        }
        modify("Cost Amount (Actual) (ACY)")
        {
            Caption = 'Cost Amount (Actual) (ACY)';
        }
        field(50008; "Precio Unitario Consignacion"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50009; "Descuento % Consignacion"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50010; "Importe Consignacion bruto"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'Antes de descuento';
        }
        field(50011; "Importe Consignacion Neto"; Decimal)
        {
            DataClassification = ToBeClassified;
            Description = 'Despues de descuento';
        }
        field(50013; "Cant. Consignacion Pendiente"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(50014; "Pedido Consignacion"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50015; "Devolucion Consignacion"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(50016; "Cod. Oferta"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        //Gabriel Prinz - The property 'Key19' can only be set if the specified fields are from the same table.ALAL0423
        // key(Key19; "Item No.", "Posting Date", "Item Ledger Entry Type", "Entry Type", "Item Charge No.", "Location Code", "Global Dimension 1 Code", "Global Dimension 2 Code", "Cod. Oferta")
        // {
        //     SumIndexFields = "Invoiced Quantity", "Sales Amount (Expected)", "Sales Amount (Actual)", "Cost Amount (Expected)", "Cost Amount (Actual)", "Cost Amount (Non-Invtbl.)", "Purchase Amount (Actual)", "Item Ledger Entry Quantity";
        // }
        key(Key20; "Location Code", "Cost Amount (Actual)", "Item No.")
        {
        }
        key(Key21; "Gen. Bus. Posting Group", "Global Dimension 1 Code", "Posting Date", "Item Ledger Entry Type", "Item No.")
        {
        }
        key(KeyReports; "Drop Shipment")
        {
        }
        key(KeyReportsExt; "Cod. Oferta")
        {
        }
    }
}

