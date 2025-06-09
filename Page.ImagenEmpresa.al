page 76257 "Imagen Empresa"
{
    ApplicationArea = all;
    PageType = Card;
    SourceTable = "Empresas Cotizacion";

    layout
    {
        area(content)
        {
            field(Imagen; rec.Imagen)
            {
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Imagen")
            {
                Caption = '&Imagen';
                action(Importar)
                {
                    Caption = 'Importar';
                    Ellipsis = true;

                    trigger OnAction()
                    begin
                        ExisteImagen := Rec.Imagen.HasValue;
                        /*    if Imagen.Import('*.bmp') = '' then
                               exit;
                           if ExisteImagen then
                               if not Confirm(Msg001, false, TableName, "Empresa cotizacion") then
                                   exit; */
                        CurrPage.SaveRecord;
                    end;
                }
                action("E&xportar")
                {
                    Caption = 'E&xportar';
                    Ellipsis = true;

                    trigger OnAction()
                    begin
                        if rec.Imagen.HasValue then;
                        /*   Imagen.Export('*.bmp'); */
                    end;
                }
                action(Borrar)
                {
                    Caption = 'Borrar';

                    trigger OnAction()
                    begin
                        if rec.Imagen.HasValue then
                            if Confirm(Msg002, false, rec.TableName, rec."Empresa cotizacion") then begin
                                Clear(rec.Imagen);
                                CurrPage.SaveRecord;
                            end;
                    end;
                }
            }
        }
    }

    var
        ExisteImagen: Boolean;
        Msg001: Label 'Do you confirm that you want to replace the previous image with %1 %2?';
        Msg002: Label 'Do you confirm that you want to delete from %1 %2?';
}

