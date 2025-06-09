#pragma implicitwith disable
page 76146 "Colegio - Work Flow Objetivos"
{
    ApplicationArea = all;
    AutoSplitKey = true;
    Caption = 'School - programming Work flow';
    DeleteAllowed = false;
    PageType = ListPlus;
    SourceTable = "Colegio - Work Flow visitas";
    SourceTableView = WHERE(Area = CONST(true));

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
                    Editable = false;
                }
                field(Mantenimiento; rec.Mantenimiento)
                {
                }
                field(Conquista; rec.Conquista)
                {
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
        CWF.SetRange(Area, true);
        if not CWF.FindFirst then begin
            DatosAux.Reset;
            DatosAux.SetRange("Tipo registro", DatosAux."Tipo registro"::"Area principal");
            DatosAux.Find('-');
            repeat
                Sec += 1000;
                Rec.Init;
                Rec."Cod. Colegio" := Rec."Cod. Colegio";
                Rec.Secuencia := Sec;
                Rec.Detalle := DatosAux.Descripcion;
                Rec."Area" := true;
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

