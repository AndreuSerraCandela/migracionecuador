#pragma implicitwith disable
page 56041 "Contenido Cajas"
{
    ApplicationArea = all;
    PageType = List;
    SourceTable = "Contenido Cajas Packing";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Cod. Barras"; rec."Cod. Barras")
                {
                }
                field(Cantidad; rec.Cantidad)
                {
                }
                field("No. Linea Picking"; rec."No. Linea Picking")
                {
                }
                field("No. Producto"; rec."No. Producto")
                {
                }
                field(Descripcion; rec.Descripcion)
                {
                }
                field("Cod. Unidad de Medida"; rec."Cod. Unidad de Medida")
                {
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action("&Cerrar Caja")
            {
                Caption = '&Cerrar Caja';

                trigger OnAction()
                begin

                    if Confirm(txt002, false) then begin
                        if LinPack.Get(Rec."No. Packing", Rec."No. Caja") then
                            if LinPack."Estado Caja" = LinPack."Estado Caja"::Abierta then begin
                                LinPack.Validate("Estado Caja", LinPack."Estado Caja"::Cerrada);
                                LinPack.Validate("Fecha Cierre Caja", WorkDate);
                                LinPack.Modify;
                                CurrPage.Close;
                            end;
                    end;
                end;
            }
        }
    }

    var
        LinPack: Record "Lin. Packing";
        txt001: Label 'Box Closed';
        txt002: Label 'Confirm that you want to close the box';


    procedure ContenidoCaja()
    begin
    end;
}

#pragma implicitwith restore

