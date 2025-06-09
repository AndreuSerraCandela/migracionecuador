page 76080 "Historico Retencion Prov."
{
    ApplicationArea = all;
    Caption = 'Histórico Retención Proveedores';
    Editable = false;
    PageType = List;
    SourceTable = "Historico Retencion Prov.";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Código Retención"; rec."Código Retención")
                {
                }
                field("Cta. Contable"; rec."Cta. Contable")
                {
                }
                field("Cód. Proveedor"; rec."Cód. Proveedor")
                {
                }
                field("Nombre Proveedor"; rec."Nombre Proveedor")
                {
                    Editable = false;
                }
                field("Base Cálculo"; rec."Base Cálculo")
                {
                }
                field(Devengo; rec.Devengo)
                {
                }
                field("Importe Retención"; rec."Importe Retención")
                {
                }
                field("Tipo Retención"; rec."Tipo Retención")
                {
                }
                field("Aplica Productos"; rec."Aplica Productos")
                {
                }
                field("No. Documento Mov. Proveedor"; rec."No. Documento Mov. Proveedor")
                {
                }
                field("Aplica Servicios"; rec."Aplica Servicios")
                {
                }
                field("Retencion IVA"; rec."Retencion IVA")
                {
                }
                field("Fecha Registro"; rec."Fecha Registro")
                {
                    Caption = 'Fecha Emisión';
                    Editable = false;
                }
                field("Importe Retenido"; rec."Importe Retenido")
                {
                }
                field("Importe Base Retencion"; rec."Importe Base Retencion")
                {
                }
                field(NCF; rec.NCF)
                {
                }
                field("No. autorizacion NCF"; rec."No. autorizacion NCF")
                {
                    Editable = false;
                }
                field("Punto Emision"; rec."Punto Emision")
                {
                    Editable = false;
                }
                field(Establecimiento; rec.Establecimiento)
                {
                    Editable = false;
                }
                field(Anulada; rec.Anulada)
                {
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        //fes mig
        /*
        CLEAR(ImporteBase);
        ImporteBase := ProcesoRetenciones.RetieneAlAbonarNew(Rec,FALSE);
        
        CLEAR(ImporteBaseDivisaLocal);
        ImporteBaseDivisaLocal := ProcesoRetenciones.RetieneAlAbonarNew(Rec,TRUE);
        CLEAR(NombreProveedor);
        NombreProveedor := ProcesoRetenciones.RetRegDocumento(Rec);
        */
        //fes mig

    end;

    var
        ImporteBase: Decimal;
        ProcesoRetenciones: Codeunit "Proceso Retenciones";
        ImporteBaseDivisaLocal: Decimal;
        NombreProveedor: Code[250];
        "Ret Doc": Record "Retencion Doc. Proveedores";
}

