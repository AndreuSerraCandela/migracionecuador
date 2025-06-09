tableextension 50055 tableextension50055 extends "No. Series Line"
{
    fields
    {
        field(55000; Tipo; Option)
        {
            Caption = 'Type';
            DataClassification = ToBeClassified;
            OptionCaption = 'Pre-Printed,Auto-Printed';
            OptionMembers = "Pre-Impreso","Auto-Impreso";
        }
        field(55001; "No. Solicitud"; Code[30])
        {
            Caption = 'Request No.';
            DataClassification = ToBeClassified;
        }
        field(55002; Emisor; Text[100])
        {
            Caption = 'Issuing';
            DataClassification = ToBeClassified;
        }
        field(55003; Estado; Option)
        {
            Caption = 'Status';
            DataClassification = ToBeClassified;
            OptionCaption = 'Authorized,Requested';
            OptionMembers = Autorizado,Solicitado;
        }
        field(55004; "No. Autorizacion"; Code[49])
        {
            Caption = 'Authorization No.';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if "No. Autorizacion" <> '' then begin

                    //$003
                    CalcFields("Facturacion electronica");
                    if "Facturacion electronica" then
                        Error(Text002);
                    //$003

                    NoSerLin.Reset;
                    NoSerLin.SetRange("No. Autorizacion", "No. Autorizacion");
                    NoSerLin.SetRange(Establecimiento, Establecimiento);
                    NoSerLin.SetRange("Punto de Emision", "Punto de Emision");
                    NoSerLin.SetRange("Tipo Comprobante", "Tipo Comprobante");
                    if NoSerLin.FindFirst then
                        if (NoSerLin."Series Code" <> "Series Code") or (NoSerLin."Line No." <> "Line No.") then
                            Error(Error001, NoSerLin."Series Code", NoSerLin."Line No.");
                    if StrLen("No. Autorizacion") < 10 then
                        Error(Error002, FieldCaption("No. Autorizacion"));
                end;
            end;
        }
        field(55005; "Fecha Autorizacion"; Date)
        {
            Caption = 'Authorization Date';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                //$003
                if "Fecha Autorizacion" <> 0D then begin
                    CalcFields("Facturacion electronica");
                    if "Facturacion electronica" then
                        Error(Text002);
                end;
                //$003
            end;
        }
        field(55006; "Fecha Caducidad"; Date)
        {
            Caption = 'Expiration Date';
            DataClassification = ToBeClassified;
        }
        field(55007; "Fecha Registro B. D."; Date)
        {
            Caption = 'DB Posting Date';
            DataClassification = ToBeClassified;
        }
        field(55008; "Tipo Autorizacion"; Option)
        {
            Caption = 'Authorization Type';
            DataClassification = ToBeClassified;
            OptionCaption = 'Temporary,Final';
            OptionMembers = Temporal,Definitiva;
        }
        field(55009; Establecimiento; Code[3])
        {
            Caption = 'Location';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if "No. Autorizacion" <> '' then begin
                    NoSerLin.Reset;
                    NoSerLin.SetRange("No. Autorizacion", "No. Autorizacion");
                    NoSerLin.SetRange(Establecimiento, Establecimiento);
                    NoSerLin.SetRange("Punto de Emision", "Punto de Emision");
                    NoSerLin.SetRange("Tipo Comprobante", "Tipo Comprobante");
                    if NoSerLin.FindFirst then
                        if (NoSerLin."Series Code" <> "Series Code") or (NoSerLin."Line No." <> "Line No.") then
                            Error(Error001, NoSerLin."Series Code", NoSerLin."Line No.");
                    if StrLen("No. Autorizacion") < 10 then
                        Error(Error002, FieldCaption("No. Autorizacion"));
                end;

                //$003
                CalcFields("Facturacion electronica");
                if "Facturacion electronica" then
                    TestField(Establecimiento);
                //$003
            end;
        }
        field(55010; "Punto de Emision"; Code[3])
        {
            Caption = 'Issue Point';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if "No. Autorizacion" <> '' then begin
                    NoSerLin.Reset;
                    NoSerLin.SetRange("No. Autorizacion", "No. Autorizacion");
                    NoSerLin.SetRange(Establecimiento, Establecimiento);
                    NoSerLin.SetRange("Punto de Emision", "Punto de Emision");
                    NoSerLin.SetRange("Tipo Comprobante", "Tipo Comprobante");
                    if NoSerLin.FindFirst then
                        if (NoSerLin."Series Code" <> "Series Code") or (NoSerLin."Line No." <> "Line No.") then
                            Error(Error001, NoSerLin."Series Code", NoSerLin."Line No.");
                    if StrLen("No. Autorizacion") < 10 then
                        Error(Error002, FieldCaption("No. Autorizacion"));
                end;

                //$003
                CalcFields("Facturacion electronica");
                if "Facturacion electronica" then
                    TestField("Punto de Emision");
                //$003
            end;
        }
        field(55011; "Tipo Comprobante"; Code[10])
        {
            Caption = 'Voucher Type';
            DataClassification = ToBeClassified;
            TableRelation = "SRI - Tabla Parametros".Code WHERE("Tipo Registro" = FILTER("TIPOS COMPROBANTES AUTORIZADOS"));

            trigger OnValidate()
            begin
                if "No. Autorizacion" <> '' then begin
                    NoSerLin.Reset;
                    NoSerLin.SetRange("No. Autorizacion", "No. Autorizacion");
                    NoSerLin.SetRange(Establecimiento, Establecimiento);
                    NoSerLin.SetRange("Punto de Emision", "Punto de Emision");
                    NoSerLin.SetRange("Tipo Comprobante", "Tipo Comprobante");
                    if NoSerLin.FindFirst then
                        if (NoSerLin."Series Code" <> "Series Code") or (NoSerLin."Line No." <> "Line No.") then
                            Error(Error001, NoSerLin."Series Code", NoSerLin."Line No.");
                    if StrLen("No. Autorizacion") < 10 then
                        Error(Error002, FieldCaption("No. Autorizacion"));
                end;

                //$003
                CalcFields("Facturacion electronica");
                if "Facturacion electronica" then
                    TestField("Tipo Comprobante");
                //$003
            end;
        }
        field(55012; "Facturacion electronica"; Boolean)
        {
            CalcFormula = Lookup("No. Series"."Facturacion electronica" WHERE(Code = FIELD("Series Code")));
            Caption = 'Facturación electrónica';
            Description = 'CompElec';
            FieldClass = FlowField;
        }
        field(55013; "Direccion Sucursal"; Text[50])
        {
            DataClassification = ToBeClassified;
            Description = '#16268';
        }
        field(55014; "Permitir Comprobante Reembolso"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(56000; "No. Resolucion"; Code[30])
        {
            Caption = 'Resolution No.';
            DataClassification = ToBeClassified;
        }
        field(56001; "Fecha Resolucion"; Date)
        {
            Caption = 'Resolution Date';
            DataClassification = ToBeClassified;
        }
        field(56002; "Tipo Generacion"; Option)
        {
            Caption = 'Generation Type';
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Electronic,Guard';
            OptionMembers = " ","Electrónico",Resguardo;
        }
        field(76042; "Expiration date"; Date)
        {
            Caption = 'Expiration date';
            DataClassification = ToBeClassified;
            Description = 'DSLoc1.03';
        }
    }
    keys
    {
        key(Key1; "No. Autorizacion")
        {
        }
    }


    //Unsupported feature: Code Insertion on "OnDelete".

    //trigger OnDelete()
    //begin
    /*
    TestField("No. Autorizacion",''); //002
    */
    //end;

    procedure getDireccionSucursal(pSeriesCode: Code[10]; pPostingDate: Date): Text[50]
    var
        lrSeriesLine: Record "No. Series Line";
        lcuNoSeriesManagement: Codeunit "No. Series";
    begin
        //#16268:Inicio
        lrSeriesLine.Reset;
        lcuNoSeriesManagement.GetNoSeriesLine(lrSeriesLine, pSeriesCode, pPostingDate, true);

        exit(lrSeriesLine."Direccion Sucursal");
        //#16268:Fin
    end;

    //Unsupported feature: Insertion (FieldGroupCollection) on "(FieldGroup: DropDown)".


    var
        Error001: Label 'The Series code %1, Line Number %2,  already has this Auth. Number';
        Error002: Label '%1 Cannot be less than 10 characters';
        Text002: Label 'En campo nº de autorización deb estar en blanco para series de facturación electrónica. ';
        NoSerLin: Record "No. Series Line";
}

