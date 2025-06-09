tableextension 50152 tableextension50152 extends "Posted Whse. Shipment Header"
{
    fields
    {
        field(55013; "Establecimiento Factura"; Code[3])
        {
            Caption = 'Invoice Location';
            DataClassification = ToBeClassified;
            Description = 'SRI';
        }
        field(55014; "Punto de Emision Factura"; Code[3])
        {
            Caption = 'Invoice Issue Point';
            DataClassification = ToBeClassified;
            Description = 'SRI';
        }
        field(56005; "Siguiente No. NCF Rem."; Code[20])
        {
            CalcFormula = Lookup("No. Series Line"."Last No. Used" WHERE("Series Code" = FIELD("No. Serie NCF Remision"),
                                                                          Open = FILTER(true)));
            FieldClass = FlowField;
        }
        field(56006; "Siguiente No. NCF Fact."; Code[20])
        {
            CalcFormula = Lookup("No. Series Line"."Last No. Used" WHERE("Series Code" = FIELD("No. Serie NCF Factura")));
            FieldClass = FlowField;
        }
        field(56042; "No. Pedido"; Code[20])
        {
            CalcFormula = Lookup("Warehouse Shipment Line"."Source No." WHERE("No." = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(56043; "Packing Completo"; Boolean)
        {
            Caption = 'Packing Complete';
            DataClassification = ToBeClassified;
        }
        field(56062; "Cantidad de Bultos"; Integer)
        {
            Caption = 'Packages Qty.';
            DataClassification = ToBeClassified;
        }
        field(76006; "No. Serie NCF Remision"; Code[10])
        {
            Caption = 'Remission Series No.';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
        field(76088; "No. Serie NCF Factura"; Code[20])
        {
            Caption = 'Invoice NCF Series No.';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";
        }
    }
}

