page 55004 "Autorizaciones SRI Proveedores"
{
    ApplicationArea = all;
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Autorizaciones SRI Proveedores";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Tipo; rec.Tipo)
                {
                }
                field("No. Solicitud"; rec."No. Solicitud")
                {
                }
                field(Emisor; rec.Emisor)
                {
                }
                field(Estado; rec.Estado)
                {
                }
                field("No. Autorizacion"; rec."No. Autorizacion")
                {
                }
                field("Tipo Documento"; rec."Tipo Documento")
                {
                }
                field("Fecha Autorizacion"; rec."Fecha Autorizacion")
                {
                }
                field("Fecha Caducidad"; rec."Fecha Caducidad")
                {
                }
                field("Fecha Registro B. D."; rec."Fecha Registro B. D.")
                {
                }
                field(Electronica; rec.Electronica)
                {
                }
                field("Tipo Autorizacion"; rec."Tipo Autorizacion")
                {
                }
                field(Establecimiento; rec.Establecimiento)
                {
                }
                field("Punto de Emision"; rec."Punto de Emision")
                {
                }
                field("Tipo Comprobante"; rec."Tipo Comprobante")
                {
                }
                field("Permitir Comprobante Reembolso"; rec."Permitir Comprobante Reembolso")
                {
                }
                field("Rango Inicio"; rec."Rango Inicio")
                {
                }
                field("Rango Fin"; rec."Rango Fin")
                {
                }
                field("Proveedor Informal"; rec."Proveedor Informal")
                {
                }
                field("Autorizacion interna"; rec."Autorizacion interna")
                {
                }
            }
        }
    }

    actions
    {
    }
}

