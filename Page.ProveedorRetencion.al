page 76041 "Proveedor - Retencion"
{
    ApplicationArea = All;
    UsageCategory = Lists;
    PageType = List;
    SourceTable = "Proveedor - Retencion";
    SourceTableView = SORTING("Cód. Proveedor", "Código Retención")
                      ORDER(Ascending);

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Código Retención"; rec."Código Retención")
                {

                    trigger OnValidate()
                    begin
                        /*FES MIG No aplica para Santillana Ecuador
                        rMaestroRet.RESET;
                        rMaestroRet.SETRANGE("Código Retención","Código Retención");
                        IF rMaestroRet.FIND('-') THEN
                          BEGIN
                            "Cta. Contable"      := rMaestroRet."Cta. Contable";
                            "Base Cálculo"       := rMaestroRet."Base Cálculo";
                            Devengo              := rMaestroRet.Devengo;
                            "Importe Retención"  := rMaestroRet."Importe Retención";
                            "Tipo Retención"     := rMaestroRet."Tipo Retención";
                            "Aplica Productos"   := rMaestroRet."Aplica Productos";
                            "Aplica Servicios"   := rMaestroRet."Aplica Servicios";
                            "Retencion IVA"    := rMaestroRet."Retencion IVA";
                          END;
                        */

                    end;
                }
                field("Cta. Contable"; rec."Cta. Contable")
                {
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
                field("Aplica Servicios"; rec."Aplica Servicios")
                {
                }
                field("Retencion IVA"; rec."Retencion IVA")
                {
                }
                field("Cód. Proveedor"; rec."Cód. Proveedor")
                {
                }
            }
        }
    }

    actions
    {
    }

    var
        rMaestroRet: Record "Config. Retencion Proveedores";
}

