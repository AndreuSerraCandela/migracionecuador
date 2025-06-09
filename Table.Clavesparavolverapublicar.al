table 55022 "Claves para volver a publicar."
{

    fields
    {
        field(1; Clave; Text[200])
        {
        }
        field(2; Documento; Code[20])
        {
        }
        field(3; "Fecha emision"; Date)
        {
        }
        field(4; "Fichero autorizacion"; Text[200])
        {
            Description = 'Esta en la carpeta DYNASOFT';
        }
        field(10; Marcar; Boolean)
        {
        }
        field(430; "Tipo documento"; Option)
        {
            Caption = 'Tipo documento';
            OptionCaption = 'Factura,Retención,Remisión,Nota Credito,Nota Debito';
            OptionMembers = Factura,Retencion,Remision,NotaCredito,NotaDebito;
        }
        field(440; "Subtipo documento"; Option)
        {
            OptionCaption = ',Venta,Transferencia';
            OptionMembers = " ",Venta,Transferencia;
        }
        field(500; "Estado envio"; Option)
        {
            Caption = 'Estado envío';
            OptionCaption = 'Pendiente,Enviado,Rechazado';
            OptionMembers = Pendiente,Enviado,Rechazado;
        }
        field(501; "Estado autorizacion"; Option)
        {
            Caption = 'Estado autorización';
            OptionCaption = 'Pendiente,Autorizado,No autorizado';
            OptionMembers = Pendiente,Autorizado,"No autorizado";
        }
    }

    keys
    {
        key(Key1; Clave)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

