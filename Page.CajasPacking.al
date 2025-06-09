#pragma implicitwith disable
page 56003 "Cajas Packing"
{
    ApplicationArea = all;
    // #4191  PLB  30/09/2014  Añadido atajo de teclado a "Cerrar caja" -> Mayús+Ctrl+C

    AutoSplitKey = true;
    DelayedInsert = true;
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
                    Editable = false;
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
            action("&Close Box")
            {
                Caption = '&Close Box';
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ShortCutKey = 'Shift+Ctrl+C';

                trigger OnAction()
                begin
                    if Confirm(txt002, false) then begin
                        CCP.Reset;
                        CCP.SetRange("No. Packing", Rec."No. Packing");
                        CCP.SetRange("No. Caja", Rec."No. Caja");
                        if CCP.FindSet then
                            repeat
                                CCP.TestField(Cantidad);
                            until CCP.Next = 0;

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
        txt001: Label 'Box Closed';
        LinPack: Record "Lin. Packing";
        txt002: Label 'Confirm that you want to close the box';
        CCP: Record "Contenido Cajas Packing";
}

#pragma implicitwith restore

