table 56025 "Cab. clas. devolucion"
{
    // #36182  19/11/2015  MOI   Se añaden los campos
    //                           -No. Serie NCF Abono
    //                           -Establecimiento Nota Credito
    //                           -Punto Emision Nota Credito

    Caption = 'Returns classification';

    fields
    {
        field(1; "No."; Code[20])
        {
        }
        field(2; "Customer no."; Code[20])
        {
            Caption = 'Customer no.';
            TableRelation = Customer;

            trigger OnValidate()
            var
                CD2: Record "Lin. clas. devoluciones";
            begin
                if "Customer no." <> '' then begin
                    Cust.Get("Customer no.");
                    "Customer name" := Cust.Name;
                end;

                if ("Customer no." <> xRec."Customer no.") and
                   (xRec."Customer no." <> '') then
                    if Confirm(Text001, false) then begin
                        CD2.Reset;
                        CD2.SetRange("No. Documento", "No.");
                        if CD2.FindFirst then
                            Error(Err001);
                    end;
            end;
        }
        field(3; "Customer name"; Text[75])
        {
            Caption = 'Customer name';
            Description = '#56924';
        }
        field(4; "Receipt date"; Date)
        {
            Caption = 'Receipt date';
        }
        field(5; Closed; Boolean)
        {
            Caption = 'Closed';
        }
        field(6; "User id"; Code[50])
        {
            Caption = 'User ID';
        }
        field(7; "Closing Datetime"; DateTime)
        {
            Caption = 'Closing Datetime';
        }
        field(8; "External document no."; Code[20])
        {
            Caption = 'External document no.';
        }
        field(9; Procesada; Boolean)
        {
        }
        field(10; Comentario; Boolean)
        {
            CalcFormula = Exist("Clas. dev. Comment Line" WHERE("No." = FIELD("No.")));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(11; "Cod. Almacen"; Code[20])
        {
            Caption = 'Location Code';
            TableRelation = Location;
        }
        field(12; "Dev. Trans. generadas"; Integer)
        {
            CalcFormula = Count("Docs. clas. devoluciones" WHERE("Tipo documento" = CONST(Transferencia),
                                                                  "No. clas. devoluciones" = FIELD("No.")));
            Caption = 'Dev. transferencia generadas';
            FieldClass = FlowField;
        }
        field(13; "Dev. ventas generadas"; Integer)
        {
            CalcFormula = Count("Docs. clas. devoluciones" WHERE("Tipo documento" = CONST(Venta),
                                                                  "No. clas. devoluciones" = FIELD("No.")));
            Caption = 'Dev. ventas generadas';
            FieldClass = FlowField;
        }
        field(14; "Usuario clasificacion"; Code[50])
        {
            Caption = 'Usuario clasificación';
        }
        field(15; "Fecha hora clasificacion"; DateTime)
        {
            Caption = 'Fecha hora clasificación';
        }
        field(16; "No Serie NCF Abono"; Code[10])
        {
            Description = '#36182';
            TableRelation = "No. Series" WHERE("Tipo Documento" = CONST("Nota de Crédito"));

            trigger OnValidate()
            var
                lrNoSeriesLine: Record "No. Series Line";
            begin
                //#36182:Inicio
                lrNoSeriesLine.Reset;
                lrNoSeriesLine.SetRange("Series Code", "No Serie NCF Abono");
                lrNoSeriesLine.SetRange(Open, true);
                if lrNoSeriesLine.FindLast then begin
                    "Establecimiento Nota Credito" := lrNoSeriesLine.Establecimiento;
                    "Punto Emision Nota Credito" := lrNoSeriesLine."Punto de Emision";
                end;
                //#36182:Fin
            end;
        }
        field(17; "Establecimiento Nota Credito"; Code[3])
        {
            Description = '#36182';
        }
        field(18; "Punto Emision Nota Credito"; Code[3])
        {
            Description = '#36182';
        }
        field(19; "Ship-to Code"; Code[10])
        {
            Caption = 'Ship-to Code';
            TableRelation = "Ship-to Address".Code WHERE("Customer No." = FIELD("Customer no."));

            trigger OnValidate()
            var
            /*   SellToCustTemplate: Record "Customer Template"; */
            begin
                /*IF ("Document Type" = "Document Type"::Order) AND
                   (xRec."Ship-to Code" <> "Ship-to Code")
                THEN BEGIN
                  SalesLine.SETRANGE("Document Type",SalesLine."Document Type"::Order);
                  SalesLine.SETRANGE("Document No.","No.");
                  SalesLine.SETFILTER("Purch. Order Line No.",'<>0');
                  IF NOT SalesLine.ISEMPTY THEN
                    ERROR(
                      Text006,
                      FIELDCAPTION("Ship-to Code"));
                  SalesLine.RESET;
                END;
                
                IF ("Document Type" <> "Document Type"::"Return Order") AND
                   ("Document Type" <> "Document Type"::"Credit Memo")
                THEN BEGIN
                  IF "Ship-to Code" <> '' THEN BEGIN
                    IF xRec."Ship-to Code" <> '' THEN
                      BEGIN
                      GetCust("Sell-to Customer No.");
                      IF Cust."Location Code" <> '' THEN
                        VALIDATE("Location Code",Cust."Location Code");
                      "Tax Area Code" := Cust."Tax Area Code";
                    END;
                    ShipToAddr.GET("Sell-to Customer No.","Ship-to Code");
                    "Ship-to Name" := ShipToAddr.Name;
                    "Ship-to Name 2" := ShipToAddr."Name 2";
                    "Ship-to Address" := COPYSTR(ShipToAddr.Address,1,50);
                
                    //034+
                    IF ShipToAddr.Colonia = '' THEN
                      "Ship-to Address 2" := ShipToAddr."Address 2"
                    ELSE
                      "Ship-to Address 2" := ShipToAddr.Colonia;
                    //034-
                
                    "Ship-to City" := ShipToAddr.City;
                    "Ship-to Post Code" := ShipToAddr."Post Code";
                    "Ship-to County" := ShipToAddr.County;
                    //011
                    "Ship-to Phone" := ShipToAddr."Phone No.";
                    //011
                    VALIDATE("Ship-to Country/Region Code",ShipToAddr."Country/Region Code");
                    "Ship-to Contact" := ShipToAddr.Contact;
                    "Shipment Method Code" := ShipToAddr."Shipment Method Code";
                    IF ShipToAddr."Location Code" <> '' THEN
                      VALIDATE("Location Code",ShipToAddr."Location Code");
                    "Shipping Agent Code" := ShipToAddr."Shipping Agent Code";
                    "Shipping Agent Service Code" := ShipToAddr."Shipping Agent Service Code";
                    IF ShipToAddr."Tax Area Code" <> '' THEN
                      "Tax Area Code" := ShipToAddr."Tax Area Code";
                    "Tax Liable" := ShipToAddr."Tax Liable";
                  END ELSE
                    IF "Sell-to Customer No." <> '' THEN BEGIN
                      GetCust("Sell-to Customer No.");
                      "Ship-to Name" := Cust.Name;
                      "Ship-to Name 2" := Cust."Name 2";
                      "Ship-to Address" := COPYSTR(Cust.Address,1,50);
                      "Ship-to Address 2" := Cust."Address 2";
                      "Ship-to City" := Cust.City;
                      "Ship-to Post Code" := Cust."Post Code";
                      "Ship-to County" := Cust.County;
                      VALIDATE("Ship-to Country/Region Code",Cust."Country/Region Code");
                      "Ship-to Contact" := Cust.Contact;
                      "Shipment Method Code" := Cust."Shipment Method Code";
                      IF NOT SellToCustTemplate.GET("Sell-to Customer Template Code") THEN BEGIN
                        "Tax Area Code" := Cust."Tax Area Code";
                        "Tax Liable" := Cust."Tax Liable";
                      END;
                      IF Cust."Location Code" <> '' THEN
                        VALIDATE("Location Code",Cust."Location Code");
                      "Shipping Agent Code" := Cust."Shipping Agent Code";
                      "Shipping Agent Service Code" := Cust."Shipping Agent Service Code";
                    END;
                END;
                
                GetShippingTime(FIELDNO("Ship-to Code"));
                
                IF (xRec."Sell-to Customer No." = "Sell-to Customer No.") AND
                   (xRec."Ship-to Code" <> "Ship-to Code")
                THEN
                  IF (xRec."VAT Country/Region Code" <> "VAT Country/Region Code") OR
                     (xRec."Tax Area Code" <> "Tax Area Code")
                  THEN
                    RecreateSalesLines(FIELDCAPTION("Ship-to Code"))
                  ELSE BEGIN
                    IF xRec."Shipping Agent Code" <> "Shipping Agent Code" THEN
                      MessageIfSalesLinesExist(FIELDCAPTION("Shipping Agent Code"));
                    IF xRec."Shipping Agent Service Code" <> "Shipping Agent Service Code" THEN
                      MessageIfSalesLinesExist(FIELDCAPTION("Shipping Agent Service Code"));
                    IF xRec."Tax Liable" <> "Tax Liable" THEN
                      VALIDATE("Tax Liable");
                  END;  */

            end;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        CD.Reset;
        CD.SetRange("No. Documento", "No.");
        if CD.Find('-') then
            CD.DeleteAll(true);
    end;

    trigger OnInsert()
    begin
        if "No." = '' then begin
            ConfEmpresa.Get;
            ConfEmpresa.TestField("No. Serie Pre Devolucion");
            //NoSeriesMgt.InitSeries(ConfEmpresa."No. Serie Pre Devolucion", ConfEmpresa."No. Serie Pre Devolucion", 0D, "No.",
            //ConfEmpresa."No. Serie Pre Devolucion");
            Rec."No." := NoSeriesMgt.GetNextNo(ConfEmpresa."No. Serie Pre Devolucion");
        end;

        "User id" := UserId;
        "Receipt date" := WorkDate;

        WHE.SetRange("User ID", UserId);
        WHE.SetRange(Default, true);
        WHE.FindFirst;
        Validate("Cod. Almacen", WHE."Location Code");
    end;

    var
        Cust: Record Customer;
        CD: Record "Lin. clas. devoluciones";
        ConfEmpresa: Record "Config. Empresa";
        NoSeriesMgt: Codeunit "No. Series";
        Text001: Label 'The customer will be changed in the lines, do you want to continue?';
        Err001: Label 'This document already have items received. To change the customer you must first delete all the lines and restart the receive';
        WHE: Record "Warehouse Employee";


    procedure AssistEdit(CR: Record "Cab. clas. devolucion"): Boolean
    begin
        Copy(Rec);
        ConfEmpresa.Get;
        ConfEmpresa.TestField("No. Serie Pre Devolucion");
        if NoSeriesMgt.LookupRelatedNoSeries(ConfEmpresa."No. Serie Pre Devolucion", ConfEmpresa."No. Serie Pre Devolucion",
                                    ConfEmpresa."No. Serie Pre Devolucion") then begin
            NoSeriesMgt.GetNextNo("No.");
            Rec := CR;

            exit(true);
        end;
    end;
}

