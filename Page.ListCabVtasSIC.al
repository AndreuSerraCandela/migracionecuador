page 50116 "List Cab Vtas SIC"
{
    ApplicationArea = all;
    Caption = 'List Cab Vtas SIC';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Cab. Ventas SIC";
    SourceTableView = SORTING (Transferido, Fecha);

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Transferido; rec.Transferido)
                {
                }
                field("Tipo documento"; rec."Tipo documento")
                {
                }
                field("No. documento"; rec."No. documento")
                {
                }
                field("No. documento SIC"; rec."No. documento SIC")
                {
                }
                field(Consecutivo; rec.Consecutivo)
                {
                }
                field("Cod. Cliente"; rec."Cod. Cliente")
                {
                }
                field(Fecha; rec.Fecha)
                {
                }
                field("Cod. Almacen"; rec."Cod. Almacen")
                {
                }
                field("Cod. Moneda"; rec."Cod. Moneda")
                {
                }
                field(RNC; rec.RNC)
                {
                }
                field("Nombre Cliente"; rec."Nombre Cliente")
                {
                }
                field("Observacion"; rec.Observacion)
                {
                }
                field("No. comprobante"; rec."No. comprobante")
                {
                }
                field("Fecha Venc. NCF"; rec."Fecha Venc. NCF")
                {
                }
                field("NCF Afectado"; rec."NCF Afectado")
                {
                }
                field("Cod. Cajero"; rec."Cod. Cajero")
                {
                }
                field("Tasa de cambio"; rec."Tasa de cambio")
                {
                }
                field("Nombre asegurado"; rec."Nombre asegurado")
                {
                }
                field("No. poliza"; rec."No. poliza")
                {
                }
                field("No. orden"; rec."No. orden")
                {
                }
                field(Aseguradora; rec.Aseguradora)
                {
                }
                field("RNC Aseguradora"; rec."RNC Aseguradora")
                {
                }
                field("Cod. supervisor"; rec."Cod. supervisor")
                {
                }
                field(Turno; rec.Turno)
                {
                }
                field("Source Counter"; rec."Source Counter")
                {
                }
                field(Errores; rec.Errores)
                {
                }
                field(ErroresLineas; rec.ErroresLineas)
                {
                }
                field(Monto; rec.Monto)
                {
                }
                field(ITBIS; rec.ITBIS)
                {
                }
                field(SubTotal; rec.SubTotal)
                {
                }
                field(Descuento; rec.Descuento)
                {
                }
                field(Caja; rec.Caja)
                {
                }
                field(Tienda; rec.Tienda)
                {
                }
                field(Establecimiento; rec.Establecimiento)
                {
                }
                field(PuntoEmision; rec.PuntoEmision)
                {
                }
                field(Colegio; rec.Colegio)
                {
                }
                field("Cod. Banco"; rec."Cod. Banco")
                {
                }
                field("Serie Documento"; rec."Serie Documento")
                {
                }
                field("Id. TPV"; rec."Id. TPV")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
        }
    }
}

