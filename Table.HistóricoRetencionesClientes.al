table 56075 "Histórico Retenciones Clientes"
{
    Caption = 'Histórico Retenciones Clientes';

    fields
    {
        field(10; Codigo; Integer)
        {
            Caption = 'Codigo';
        }
        field(80; "Tipo Retención"; Option)
        {
            Caption = 'Tipo Retención';
            Description = '#34822';
            OptionCaption = ' ,Renta,IVA';
            OptionMembers = " ",Renta,IVA;
        }
        field(90; "Tipo Documento"; Option)
        {
            Caption = 'Applies-to Doc. Type';
            OptionCaption = ' ,Payment,Invoice,Credit Memo,Finance Charge Memo,Reminder,Refund';
            OptionMembers = " ",Payment,Invoice,"Credit Memo","Finance Charge Memo",Reminder,Refund;
        }
        field(100; "No. documento"; Code[20])
        {
            Caption = 'No. documento';
            Editable = false;
            NotBlank = true;
            TableRelation = "Sales Invoice Header"."No." WHERE("Bill-to Customer No." = FIELD("Cód. Cliente"));
        }
        field(110; "Cód. Cliente"; Code[20])
        {
            Caption = 'Cód. Cliente';
            TableRelation = Customer."No.";

            trigger OnValidate()
            var
                Cust: Record Customer;
            begin
            end;
        }
        field(120; "Nombre Cliente"; Text[100])
        {
            Caption = 'Nombre Cliente';
            Editable = false;
        }
        field(130; "Fecha Registro"; Date)
        {
            Caption = 'Fecha Registro';
        }
        field(160; "Importe Retenido"; Decimal)
        {
            Caption = 'Importe Retenido';
        }
        field(200; "Establecimiento Factura"; Code[3])
        {
            Caption = 'Invoice Location';
            Description = 'SRI';
        }
        field(210; "Punto de Emision Factura"; Code[3])
        {
            Caption = 'Invoice Issue Point';
            Description = 'SRI';
        }
        field(220; "No. Comprobante Fiscal"; Code[19])
        {
            Caption = 'No. Comprobante Fiscal';
        }
        field(230; "No. Autorizacion Comprobante"; Code[49])
        {
            Caption = 'Authorization Voucher No.';
            Description = 'SRI';
        }
        field(231; "No. Movimiento Cliente"; Integer)
        {
            Caption = 'No. Movimiento Cliente';
        }
    }

    keys
    {
        key(Key1; Codigo)
        {
            Clustered = true;
        }
        key(Key2; "Fecha Registro", "Cód. Cliente")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        rRec: Record "Histórico Retenciones Clientes";
        Err002: Label 'Número de factura incorrecto';
    begin

        if rRec.FindLast then
            Codigo := rRec.Codigo + 1
        else
            Codigo := 1;
    end;

    trigger OnModify()
    var
        Err002: Label 'Número de factura incorrecto';
    begin
    end;

    trigger OnRename()
    var
        rRec: Record "Histórico Retenciones Clientes";
    begin
    end;

    var
        SIH: Record "Sales Invoice Header";


    procedure ValorRetenido()
    begin
        //"Valor retenido" := 0;

        //IF ("Porcentaje retener" <>0) AND ("Base imponible" <> 0) THEN
        //  "Valor retenido" := ("Base imponible" * "Porcentaje retener" / 100);
    end;


    procedure ValidaDocumento()
    var
        rSIH: Record "Sales Invoice Header";
        rSCMH: Record "Sales Cr.Memo Header";
        Err001: Label 'El numero de factura ingresado no existe.';
    begin
        /*
        IF ("No. Autorizacion Comprobante" <> '') AND ("Punto de Emision Factura" <> '') AND
           ("No. Comprobante Fiscal" <> '') AND ("No. Autorizacion Comprobante" <> '') THEN BEGIN
          rSIH.SETRANGE("Establecimiento Factura","No. Autorizacion Comprobante");
          rSIH.SETRANGE("Punto de Emision Factura","Punto de Emision Factura");
          rSIH.SETRANGE("No. Comprobante Fiscal","No. Comprobante Fiscal");
          rSIH.SETRANGE("No. Autorizacion Comprobante","No. Autorizacion Comprobante");
          IF NOT rSIH.FINDSET THEN
            ERROR(Err001);
          Fecha := rSIH."Posting Date";
          "No. documento"  := rSIH."No."
        END
        */

    end;


    procedure LookupDocumento()
    begin
        /*
        SIH.SETRANGE(SIH."Bill-to Customer No.","Cód. Cliente");
        IF PAGE.RUNMODAL(0, SIH) = ACTION::LookupOK THEN BEGIN
          "Punto de Emision Factura" := SIH."Punto de Emision Factura";
          "No. Autorizacion Comprobante" := SIH."Establecimiento Factura";
          "No. Comprobante Fiscal" := SIH."No. Comprobante Fiscal";
          "No. Autorizacion Comprobante" := SIH."No. Autorizacion Comprobante";
          ValidaDocumento();
        END;
        */

    end;
}

