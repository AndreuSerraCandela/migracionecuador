tableextension 50054 tableextension50054 extends "No. Series"
{
    DataCaptionFields = "Code", Description, "Facturacion electronica";
    fields
    {
        field(50000; "Tipo Documento"; Option)
        {
            Caption = 'Document Type';
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Invoice,Credit Memo';
            OptionMembers = " ",Factura,"Nota de Crédito",Remision,Retencion;
        }
        field(50001; "Cod. Almacen"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = '#SANTINAV-2647';
            TableRelation = Location.Code;
        }
        field(50010; "Centro de Responsabilidad"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = '#17986';
            TableRelation = "Responsibility Center";
        }
        field(55000; "Facturacion electronica"; Boolean)
        {
            Caption = 'Facturación electrónica';
            DataClassification = ToBeClassified;
            Description = 'CompElec';

            trigger OnValidate()
            begin

                if "Facturacion electronica" then   //$001
                    ControlSerieFE;                  //
            end;
        }
        field(76041; "Descripcion NCF"; Text[250])
        {
            DataClassification = ToBeClassified;
            Description = 'AMS - Agregado para configurar el mensaje de NCF en la impresion de documentos';
        }
        field(76079; "Invoice Copies"; Integer)
        {
            Caption = 'Invoice Copies';
            DataClassification = ToBeClassified;
        }
    }

    local procedure ControlSerieFE()
    var
        NoSeriesLine: Record "No. Series Line";
        NoSeriesMgt: Codeunit "No. Series";
    begin
        NoSeriesMgt.GetNoSeriesLine(NoSeriesLine, Code, 0D, true);
        NoSeriesLine.FindFirst;

        NoSeriesLine.TestField("Starting No.");
        NoSeriesLine.TestField(Establecimiento);
        NoSeriesLine.TestField("Punto de Emision");
        NoSeriesLine.TestField("Tipo Comprobante");

        if StrLen(NoSeriesLine.Establecimiento) <> 3 then
            Error(Text003);

        if StrLen(NoSeriesLine."Punto de Emision") <> 3 then
            Error(Text004);

        if StrLen(NoSeriesLine."Starting No.") <> 9 then
            Error(Text005);

        if (NoSeriesLine."No. Autorizacion" <> '') then
            Error(Text002, NoSeriesLine."No. Autorizacion");
    end;

    procedure ActualizarAutorizacionTemp()
    var
        NoSeriesLine: Record "No. Series Line";
        NoSeriesMgt: Codeunit "No. Series";
    begin
        NoSeriesMgt.GetNoSeriesLine(NoSeriesLine, Code, 0D, true);
        if NoSeriesLine.FindFirst then begin
            if (NoSeriesLine."No. Autorizacion" <> '') and (NoSeriesLine."No. Autorizacion" <> Code) then
                Error(Text002, NoSeriesLine."No. Autorizacion");

            NoSeriesLine."No. Autorizacion" := Code + ' TEMP';
            NoSeriesLine.Modify;
        end;
    end;

    var
        Text001: Label 'Debe indicar la numeración inicial de la serie.';
        Text002: Label 'En nº de autorización %1 no es valido para las series NCF de facturación electrónica. Debe dejarlo en blanco antes de activar la serie.';
        Text003: Label 'El establecimiento es incorrecto.';
        Text004: Label 'El punto de emisión es incorrecto.';
        Text005: Label 'El longitud del número inicial no puede superar los 9 digitos.';
}

