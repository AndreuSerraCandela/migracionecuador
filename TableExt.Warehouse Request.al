tableextension 50118 tableextension50118 extends "Warehouse Request"
{
    fields
    {
        field(50000; "Comentario Doc. Origen"; Boolean)
        {
            CalcFormula = Exist("Sales Header" WHERE("Document Type" = FIELD("Source Document"),
                                                      Comment = FILTER(true),
                                                      "No." = FIELD("Source No.")));
            Caption = 'Source Doc. comment';
            FieldClass = FlowField;
        }
        field(56001; "Nombre Cliente"; Text[150])
        {
            Caption = 'Customer Name';
        }
        field(56002; "Pedido Consignacion"; Boolean)
        {
            Caption = 'Consignment Order';
        }
        field(56003; "Cantidades Pendientes Ped. Vta"; Decimal)
        {
            CalcFormula = Sum("Sales Line"."Outstanding Quantity" WHERE("Document Type" = FILTER(Order | "Return Order"),
                                                                         "Document No." = FIELD("Source No.")));
            Caption = 'Sales Order Outstanding Quantity';
            FieldClass = FlowField;
        }
        field(56004; "Cantidades Pendientes Ped. Tr."; Decimal)
        {
            CalcFormula = Sum("Transfer Line"."Outstanding Quantity" WHERE("Document No." = FIELD("Source No.")));
            Caption = 'Transfer Order Outstanding Quantity';
            FieldClass = FlowField;
        }
        field(56005; Pendiente; Boolean)
        {
            Caption = 'Pending';
        }
        field(56006; "Cantidades Pend. Ped. Compra"; Decimal)
        {
            CalcFormula = Sum("Purchase Line"."Outstanding Quantity" WHERE("Document Type" = FILTER(Order | "Return Order"),
                                                                            "Document No." = FIELD("Source No.")));
            FieldClass = FlowField;
        }
    }
    keys
    {
        key(Key7; "Shipment Date")
        {
        }
    }
}

