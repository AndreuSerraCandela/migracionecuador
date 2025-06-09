pageextension 50065 pageextension50065 extends "No. Series Lines"
{
    layout
    {
        addafter("Series Code")
        {
            field(Tipo; rec.Tipo)
            {
                ApplicationArea = Basic, Suite;
            }
            field("No. Solicitud"; rec."No. Solicitud")
            {
                ApplicationArea = Basic, Suite;
            }
            field(Emisor; rec.Emisor)
            {
                ApplicationArea = Basic, Suite;
            }
            field(Estado; rec.Estado)
            {
                ApplicationArea = Basic, Suite;
            }
            field("No. Autorizacion"; rec."No. Autorizacion")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Fecha Autorizacion"; rec."Fecha Autorizacion")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Fecha Caducidad"; rec."Fecha Caducidad")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Fecha Registro B. D."; rec."Fecha Registro B. D.")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Tipo Autorizacion"; rec."Tipo Autorizacion")
            {
                ApplicationArea = Basic, Suite;
            }
            field(Establecimiento; rec.Establecimiento)
            {
                ApplicationArea = Basic, Suite;
            }
            field("Punto de Emision"; rec."Punto de Emision")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Tipo Comprobante"; rec."Tipo Comprobante")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Permitir Comprobante Reembolso"; rec."Permitir Comprobante Reembolso")
            {
                ApplicationArea = Basic, Suite;
            }
            field("No. Resolucion"; rec."No. Resolucion")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Fecha Resolucion"; rec."Fecha Resolucion")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Tipo Generacion"; rec."Tipo Generacion")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Expiration date"; rec."Expiration date")
            {
                ApplicationArea = Basic, Suite;
            }
            field("Direccion Sucursal"; rec."Direccion Sucursal")
            {
                ApplicationArea = Basic, Suite;
            }
        }


    }
}