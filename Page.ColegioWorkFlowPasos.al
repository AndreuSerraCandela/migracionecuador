#pragma implicitwith disable
page 76147 "Colegio - Work Flow Pasos"
{
    ApplicationArea = all;
    Caption = 'School - steps Work flow';
    DeleteAllowed = false;
    PageType = ListPlus;
    SourceTable = "Colegio - Work Flow visitas";
    SourceTableView = WHERE(Paso = CONST(true));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Cod. Colegio"; rec."Cod. Colegio")
                {
                    Editable = false;
                    Visible = false;
                }
                field(Detalle; rec.Detalle)
                {
                    Caption = 'Step';
                    Editable = false;
                }
                field(Resultado; rec.Resultado)
                {

                    trigger OnValidate()
                    var
                        Error001: Label 'Es obligatorio marcar los pasos de forma ordenada, del primero al último.';
                        Error002: Label 'No se permite desmarcar pasos.';
                    begin

                        if Rec.Resultado then begin
                            CWF.Reset;
                            CWF.SetRange("Cod. Colegio", Rec."Cod. Colegio");
                            CWF.SetRange(Paso, true);
                            CWF.SetFilter(Detalle, '<>%1', Rec.Detalle);
                            CWF.SetRange(Resultado, false);
                            if CWF.FindFirst then begin
                                if CWF.Secuencia < Rec.Secuencia then
                                    Error(Error001);
                            end;
                        end
                        else begin
                            CWF.Reset;
                            CWF.SetRange("Cod. Colegio", Rec."Cod. Colegio");
                            CWF.SetRange(Paso, true);
                            CWF.SetFilter(Detalle, '<>%1', Rec.Detalle);
                            CWF.SetRange(Resultado, true);
                            if CWF.FindLast then begin
                                if CWF.Secuencia > Rec.Secuencia then
                                    Error(Error001);
                            end;

                        end;
                    end;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        Sec := 0;
        CWF.Reset;
        CWF.SetRange("Cod. Promotor", Rec."Cod. Promotor");
        CWF.SetRange("Cod. Colegio", Rec."Cod. Colegio");
        CWF.SetRange(Paso, true);
        if not CWF.FindFirst then begin
            DatosAux.Reset;
            DatosAux.SetRange("Tipo registro", DatosAux."Tipo registro"::Paso);
            DatosAux.Find('-');
            repeat
                Sec += 1000;
                Rec.Init;
                Rec."Cod. Colegio" := Rec."Cod. Colegio";
                Rec.Secuencia := Sec;
                Rec.Detalle := DatosAux.Descripcion;
                Rec.Paso := true;
                Rec.Insert;
            until DatosAux.Next = 0;
        end;
    end;

    var
        CWF: Record "Colegio - Work Flow visitas";
        DatosAux: Record "Datos auxiliares";
        Sec: Integer;
}

#pragma implicitwith restore

