page 76424 "Visitas A/C - Grupos Negocio"
{
    ApplicationArea = all;
    DeleteAllowed = false;
    InsertAllowed = false;
    LinksAllowed = false;
    PageType = List;
    SourceTable = "Visitas A/C-Dis. Centros Costo";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("Código"; rec.Código)
                {
                }
                field("Descripción"; rec.Descripción)
                {
                }
                field(Porcentaje; rec.Porcentaje)
                {
                    Caption = '%';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    var
        DistrCentros: Record "Dis. Centros Costo";
        UserSetup: Record "User Setup";
    begin

        CurrPage.Editable := wEditable;

        if not rec.FindFirst then
            Calcular;
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    var
        rDist: Record "Visitas A/C-Dis. Centros Costo";
        wPorc: Decimal;
        Err001: Label 'El porcentaje de los centros de coste no deben ser mayores de 100.';
        Err002: Label 'El porcentaje de los centros de coste no deben ser menores de 0.';
    begin

        rDist.Copy(Rec);
        if rDist.FindSet then
            repeat
                wPorc += rDist.Porcentaje;
            until rDist.Next = 0;

        if wPorc > 100 then
            Error(Err001);

        if wPorc < 0 then
            Error(Err002);
    end;

    var
        gCodColegio: Code[20];
        wEditable: Boolean;
        wVisita: Code[20];


    procedure RecibeParametros(parVisita: Code[20]; parEditable: Boolean)
    var
        rGrupoCOL: Record "Grupo de Colegios";
    begin

        wEditable := parEditable;
        wVisita := parVisita;

        rec.SetRange("No. Visita Consultor/Asesor", parVisita);
    end;


    procedure Calcular()
    var
        DistrCentros: Record "Visitas A/C-Dis. Centros Costo";
        da: Record "Datos auxiliares";
        TotalGen: Decimal;
        Total: Decimal;
        Porciento: Decimal;
    begin



        da.SetRange("Tipo registro", da."Tipo registro"::"Grupo de Negocio");
        if da.FindSet then
            repeat
                Total := 0;
                Porciento := 0;

                DistrCentros.Init;
                DistrCentros."No. Visita Consultor/Asesor" := wVisita;
                DistrCentros.Código := da.Codigo;
                DistrCentros.Descripción := da.Descripcion;
                DistrCentros.Porcentaje := Porciento;
                DistrCentros.Insert;
            until da.Next = 0;
    end;
}

