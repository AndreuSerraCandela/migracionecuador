tableextension 50150 tableextension50150 extends "Warehouse Shipment Header"
{
    fields
    {
        field(51000; "Boxes Quatity"; Decimal)
        {
            Caption = 'Boxes Quatity';
            DataClassification = ToBeClassified;
        }
        field(51001; "Bags Quantity"; Decimal)
        {
            Caption = 'Bags Quantity';
            DataClassification = ToBeClassified;
        }
        field(51002; "Driver Code"; Code[10])
        {
            Caption = 'Driver Code';
            DataClassification = ToBeClassified;
            TableRelation = "Lista de Choferes";

            trigger OnValidate()
            var
                Driver: Record "Lista de Choferes";
            begin
                Driver.Get("Driver Code");
                "Driver Name" := Driver."Nombre Completo";
            end;
        }
        field(51003; "Driver Name"; Text[30])
        {
            Caption = 'Driver Name';
            DataClassification = ToBeClassified;
        }
        field(55013; "Establecimiento Factura"; Code[3])
        {
            Caption = 'Invoice Location';
            DataClassification = ToBeClassified;
            Description = 'SRI';

            trigger OnValidate()
            begin
                TestField("No. Serie NCF Factura");
                //001
                WHSL.Reset;
                WHSL.SetRange("No.", "No.");
                WHSL.FindSet;
                repeat
                    if SH.Get(WHSL."Source Subtype", WHSL."Source No.") then begin
                        SH.Validate("No. Serie NCF Remision", "No. Serie NCF Remision");
                        SH.Validate("Establecimiento Factura", "Establecimiento Factura");
                        //SH.VALIDATE("Punto de Emision Factura","Punto de Emision Factura");
                        SH.Modify;
                    end;

                    //Transferencia
                    if TH.Get(WHSL."Source No.") then begin
                        TH.Validate(TH."No. Serie Comprobante Fiscal", "No. Serie NCF Remision");
                        TH.Modify;
                    end;

                until WHSL.Next = 0;
                //001
            end;
        }
        field(55014; "Punto de Emision Factura"; Code[3])
        {
            Caption = 'Invoice Issue Point';
            DataClassification = ToBeClassified;
            Description = 'SRI';

            trigger OnValidate()
            begin
                TestField("No. Serie NCF Factura");
                TestField("Establecimiento Factura");
                //001
                WHSL.Reset;
                WHSL.SetRange("No.", "No.");
                WHSL.FindSet;
                repeat
                    if SH.Get(WHSL."Source Subtype", WHSL."Source No.") then begin
                        SH.Validate("No. Serie NCF Remision", "No. Serie NCF Remision");
                        SH.Validate("Establecimiento Factura", "Establecimiento Factura");
                        SH.Validate("Punto de Emision Factura", "Punto de Emision Factura");
                        SH.Modify;
                    end;

                    //Transferencia
                    if TH.Get(WHSL."Source No.") then begin
                        TH.Validate(TH."No. Serie Comprobante Fiscal", "No. Serie NCF Remision");
                        TH.Modify;
                    end;

                until WHSL.Next = 0;
            end;
        }
        field(55015; "Fecha inicio transporte"; Date)
        {
            Caption = 'Fecha inicio transporte';
            DataClassification = ToBeClassified;
            Description = '$002';
        }
        field(55016; "Fecha fin transporte"; Date)
        {
            Caption = 'Fecha fin transporte';
            DataClassification = ToBeClassified;
            Description = '$002';
        }
        field(56005; "Siguiente No. NCF Rem."; Code[20])
        {
            CalcFormula = Lookup("No. Series Line"."Last No. Used" WHERE("Series Code" = FIELD("No. Serie NCF Remision"),
                                                                          Open = FILTER(true)));
            FieldClass = FlowField;
        }
        field(56006; "Siguiente No. NCF Fact."; Code[20])
        {
            CalcFormula = Lookup("No. Series Line"."Last No. Used" WHERE("Series Code" = FIELD("No. Serie NCF Factura"),
                                                                          Establecimiento = FIELD("Establecimiento Factura"),
                                                                          "Punto de Emision" = FIELD("Punto de Emision Factura"),
                                                                          Open = FILTER(true)));
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
            TableRelation = "No. Series" WHERE("Tipo Documento" = CONST(Remision));

            trigger OnValidate()
            begin
                //001
                WHSL.Reset;
                WHSL.SetRange("No.", "No.");
                if WHSL.FindSet then
                    repeat
                        if SH.Get(WHSL."Source Subtype", WHSL."Source No.") then begin
                            SH.Validate("No. Serie NCF Remision", "No. Serie NCF Remision");
                            SH.Modify;
                        end;

                        //Transferencia
                        if TH.Get(WHSL."Source No.") then begin
                            TH.Validate(TH."No. Serie Comprobante Fiscal", "No. Serie NCF Remision");
                            TH.Modify;
                        end;

                    until WHSL.Next = 0;
                //001
            end;
        }
        field(76088; "No. Serie NCF Factura"; Code[20])
        {
            Caption = 'Invoice NCF Series No.';
            DataClassification = ToBeClassified;
            TableRelation = "No. Series" WHERE("Tipo Documento" = CONST(Factura));

            trigger OnValidate()
            begin
                //001
                WHSL.Reset;
                WHSL.SetRange("No.", "No.");
                if WHSL.FindSet then
                    repeat
                        if SH.Get(WHSL."Source Subtype", WHSL."Source No.") then begin
                            SH.Validate(SH."No. Serie NCF Facturas", "No. Serie NCF Factura");
                            SH.Modify;
                        end;
                    until WHSL.Next = 0;
                //001
            end;
        }
    }

    var
        "***Santillana***": Integer;
        WHSL: Record "Warehouse Shipment Line";
        SH: Record "Sales Header";
        TH: Record "Transfer Header";
}

