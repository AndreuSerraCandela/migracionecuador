tableextension 50084 tableextension50084 extends "IC Inbox Purchase Header"
{
    fields
    {
        field(55000; "Sustento del Comprobante"; Code[10])
        {
            Caption = 'Voucher Sustentation';
            DataClassification = ToBeClassified;
            Description = 'SANTINAV-5893';
            TableRelation = "SRI - Tabla Parametros".Code WHERE("Tipo Registro" = FILTER("SUSTENTO DEL COMPROBANTE"));
        }
        field(55001; "Tipo de Comprobante"; Code[10])
        {
            Caption = 'Voucher Type';
            DataClassification = ToBeClassified;
            Description = 'SANTINAV-5893';
            TableRelation = "SRI - Tabla Parametros".Code WHERE("Tipo Registro" = FILTER("TIPOS COMPROBANTES AUTORIZADOS"));

            trigger OnValidate()
            var
                Err001: Label 'Se requiere eliminar las lineas de reembolso.';
                recFactRespaldo: Record "Facturas de reembolso";
            begin
            end;
        }
        field(55003; Establecimiento; Code[3])
        {
            DataClassification = ToBeClassified;
            Description = 'SANTINAV-5893';
        }
        field(55005; "Punto de Emision"; Code[3])
        {
            DataClassification = ToBeClassified;
            Description = 'SANTINAV-5893';
        }
        field(55013; "Establecimiento Factura"; Code[3])
        {
            Caption = 'Invoice Location';
            DataClassification = ToBeClassified;
            Description = 'SANTINAV-5893';
            Enabled = false;

            trigger OnValidate()
            begin
                /*
                TESTFIELD("No. Serie NCF Facturas");
                NoSeriesLine.RESET;
                NoSeriesLine.SETRANGE("Series Code","No. Serie NCF Facturas");
                NoSeriesLine.SETRANGE(Establecimiento,"Establecimiento Factura");
                NoSeriesLine.FINDFIRST;
                */

            end;
        }
        field(55014; "Punto de Emision Factura"; Code[3])
        {
            Caption = 'Invoice Issue Point';
            DataClassification = ToBeClassified;
            Description = 'SANTINAV-5893';
            Enabled = false;

            trigger OnValidate()
            begin
                /*
                //017
                TESTFIELD("No. Serie NCF Facturas");
                TESTFIELD("Establecimiento Factura");
                NoSeriesLine.RESET;
                NoSeriesLine.SETRANGE("Series Code","No. Serie NCF Facturas");
                NoSeriesLine.SETRANGE(Establecimiento,"Establecimiento Factura");
                NoSeriesLine.SETRANGE("Punto de Emision","Punto de Emision Factura");
                NoSeriesLine.FINDFIRST;
                //017
                */

            end;
        }
        field(55025; "No. Serie NCF Retencion"; Code[10])
        {
            Caption = 'Nº Serie NCF Retención';
            DataClassification = ToBeClassified;
            Description = 'SANTINAV-5893';
            TableRelation = "No. Series";

            trigger OnValidate()
            var
                recLinSerie: Record "No. Series Line";
                cduNoSeriesMgt: Codeunit "No. Series";
            begin
            end;
        }
        field(56009; "Factura eletrónica"; Boolean)
        {
            DataClassification = ToBeClassified;
            Description = 'SANTINAV-5893';
        }
        field(76079; "No. Comprobante Fiscal"; Code[19])
        {
            Caption = 'Fiscal Document No.';
            DataClassification = ToBeClassified;
            Description = 'SANTINAV-5893';
        }
        field(76080; "No. Comprobante Fiscal Rel."; Code[19])
        {
            Caption = 'Related Fiscal Document No.';
            DataClassification = ToBeClassified;
            Description = 'SANTINAV-5893';
        }
    }
}

