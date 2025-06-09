tableextension 50146 tableextension50146 extends "Warehouse Receipt Header"
{
    fields
    {
        field(55013; "Establecimiento Nota. CR."; Code[3])
        {
            Caption = 'Invoice Location';
            DataClassification = ToBeClassified;
            Description = 'SRI';

            trigger OnValidate()
            begin
                TestField("No. Serie NCF NCR.");
                //001
                WHRL.Reset;
                WHRL.SetRange("No.", "No.");
                WHRL.FindSet;
                repeat
                    if SH.Get(WHRL."Source Subtype", WHRL."Source No.") then begin
                        SH.Validate("Establecimiento Factura", "Establecimiento Nota. CR.");
                        //SH.VALIDATE("Punto de Emision Factura","Punto de Emision Factura");
                        SH.Modify;
                    end;


                until WHRL.Next = 0;
                //001
            end;
        }
        field(55014; "Punto de Emision Nota. CR."; Code[3])
        {
            Caption = 'Invoice Issue Point';
            DataClassification = ToBeClassified;
            Description = 'SRI';

            trigger OnValidate()
            begin
                TestField("No. Serie NCF NCR.");
                TestField("Establecimiento Nota. CR.");
                //001
                WHRL.Reset;
                WHRL.SetRange("No.", "No.");
                WHRL.FindSet;
                repeat
                    if SH.Get(WHRL."Source Subtype", WHRL."Source No.") then begin
                        SH.Validate("Establecimiento Factura", "Establecimiento Nota. CR.");
                        SH.Validate("Punto de Emision Factura", "Punto de Emision Nota. CR.");
                        SH.Modify;
                    end;


                until WHRL.Next = 0;
                //001
            end;
        }
        field(56006; "Siguiente No. NCF NCR."; Code[20])
        {
            CalcFormula = Lookup("No. Series Line"."Last No. Used" WHERE("Series Code" = FIELD("No. Serie NCF NCR."),
                                                                          Establecimiento = FIELD("Establecimiento Nota. CR."),
                                                                          "Punto de Emision" = FIELD("Punto de Emision Nota. CR."),
                                                                          Open = FILTER(true)));
            FieldClass = FlowField;
        }
        field(56042; "No. Pedido"; Code[20])
        {
            CalcFormula = Lookup("Warehouse Shipment Line"."Source No." WHERE("No." = FIELD("No.")));
            FieldClass = FlowField;
        }
        field(76088; "No. Serie NCF NCR."; Code[20])
        {
            Caption = 'Invoice NCF Series No.';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series";

            trigger OnValidate()
            begin
                //001
                WHRL.Reset;
                WHRL.SetRange("No.", "No.");
                if WHRL.FindSet then
                    repeat
                        if SH.Get(WHRL."Source Subtype", WHRL."Source No.") then begin
                            SH.Validate(SH."No. Serie NCF Facturas", "No. Serie NCF NCR.");
                            SH.Modify;
                        end;
                    until WHRL.Next = 0;
                //001
            end;
        }
    }

    var
        "***Santilllana***": Integer;
        SH: Record "Sales Header";
        TH: Record "Transfer Header";
        WHRL: Record "Warehouse Receipt Line";
}

