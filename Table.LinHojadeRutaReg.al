table 56023 "Lin. Hoja de Ruta Reg."
{
    // Proyecto: Microsoft Dynamics Nav
    // ------------------------------------------------------------------------------
    // LDP: Luis Jose De La Cruz
    // ------------------------------------------------------------------------------
    // No.           Firma         Fecha           Descripción
    // ------------------------------------------------------------------------------
    // 002           LDP           23/04/2024       SANTINAV-6431: Se cre campo Municipio/Ciudad

    Caption = 'Posted Route Sheet Posted';

    fields
    {
        field(1; "No. Hoja Ruta"; Code[20])
        {
            Caption = 'Route Sheet No.';
        }
        field(2; "No. Linea"; Integer)
        {
            Caption = 'Line No.';
        }
        field(3; "No. Conduce"; Code[20])
        {
            Caption = 'Shipment No.';
            TableRelation = "Sales Shipment Header";

            trigger OnValidate()
            begin
                if SHH.Get("No. Conduce") then begin
                    Cust.Get(SHH."Sell-to Customer No.");
                    "Cod. Cliente" := Cust."No.";
                    "Nombre Cliente" := Cust.Name;
                end;
            end;
        }
        field(4; "Cod. Cliente"; Code[20])
        {
            Caption = 'Customer Code';
            TableRelation = Customer;
        }
        field(5; "Nombre Cliente"; Text[200])
        {
            Caption = 'Customer Name';
            Description = '#56924';
        }
        field(6; "Cantidad de Bultos"; Integer)
        {
            Caption = 'Packages Qty.';
        }
        field(7; Peso; Decimal)
        {
            Caption = 'Weight';
        }
        field(8; "Unidad Medida"; Code[10])
        {
            Caption = 'Unit of Measure';
            TableRelation = "Unit of Measure";
        }
        field(9; Valor; Decimal)
        {
            Caption = 'Value';
        }
        field(10; "No. Guia"; Code[20])
        {
            Caption = 'Shipment Guide No.';
        }
        field(11; Comentarios; Text[250])
        {
            Caption = 'Comments';
        }
        field(12; "Fecha Entrega Requerida"; Date)
        {
            Caption = 'Fecha Entrega Requerida';
        }
        field(13; "Condiciones de Envio"; Text[200])
        {
            Caption = 'Shipping Conditions';
        }
        field(14; "No. Pedido"; Code[20])
        {
            Caption = 'Order No.';
        }
        field(15; "Fecha Pedido"; Date)
        {
            Caption = 'Order Date';
        }
        field(16; "No entregado"; Boolean)
        {
            Caption = 'Not Shipped';
        }
        field(17; "Tipo Envio"; Option)
        {
            Caption = 'Shippment Type';
            OptionCaption = ' ,Transfer,Sales Order';
            OptionMembers = " ",Transferencia,"Pedido Venta";
        }
        field(18; "No. Factura"; Code[20])
        {
            Caption = 'Invoice No.';
            TableRelation = "Sales Invoice Header" WHERE("Order No." = FIELD("No. Pedido"),
                                                          "Sell-to Customer No." = FIELD("Cod. Cliente"));
        }
        field(20; "Comprobante Fiscal"; Code[19])
        {
            Caption = 'Comprobante Fiscal';
            Description = '#32014';
        }
        field(23; "Horario Entrega"; Text[100])
        {
            Description = 'Santinav-599';
        }
        field(24; "Entrega En"; Text[100])
        {
            Description = 'Santinav-599';
        }
        field(55048; "Numero Guia"; Code[20])
        {
            Caption = 'Número de Guía';
            Description = 'SANTINAV-1401';
        }
        field(55049; "Nombre Guia"; Code[20])
        {
            Caption = 'Nombre de Guía';
            Description = 'SANTINAV-1401';
        }
        field(55055; "Ship-to City"; Text[60])
        {
            Caption = 'Ship-to City';
            DataClassification = ToBeClassified;
            Description = 'SANTINAV-6431';
            TableRelation = "Post Code".City;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
    }

    keys
    {
        key(Key1; "No. Hoja Ruta", "No. Linea")
        {
            Clustered = true;
        }
        key(Key2; "No. Guia")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Cust: Record Customer;
        SHH: Record "Sales Shipment Header";
        Error001: Label 'This Guide No. already exists in the Route Sheet %1, Line %2';


    procedure NumGuia()
    var
        CHR: Record "Cab. Hoja de Ruta";
        SA: Record "Shipping Agent";
        NosSeries: Record "No. Series";
        NoSerieMagmt: Codeunit "No. Series";
        LHR: Record "Lin. Hoja de Ruta";
    begin
        CHR.Get("No. Hoja Ruta");
        CHR.TestField("Cod. Transportista");
        SA.Get(CHR."Cod. Transportista");
        if SA."No. Serie Guias" <> '' then begin
            if "No. Guia" = '' then begin
                "No. Guia" := NoSerieMagmt.GetNextNo(SA."No. Serie Guias", WorkDate, true);
                LHR.Reset;
                LHR.SetCurrentKey("No. Guia");
                LHR.SetRange("No. Guia", "No. Guia");
                if LHR.FindFirst then
                    Error(Error001, "No. Guia", LHR."No. Linea");
                Modify;
            end;
        end;
    end;
}

