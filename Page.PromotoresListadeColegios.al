page 76364 "Promotores - Lista de Colegios"
{
    ApplicationArea = all;
    PageType = ListPlus;
    SourceTable = "Promotor - Lista de Colegios";
    SourceTableView = SORTING("Nombre Colegio");

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field(Seleccionar; rec.Seleccionar)
                {
                }
                field("Cod. Promotor"; rec."Cod. Promotor")
                {
                    Editable = false;
                }
                field("Cod. Colegio"; rec."Cod. Colegio")
                {
                    Editable = false;
                }
                field("Nombre Colegio"; rec."Nombre Colegio")
                {
                    Editable = false;
                }
                field("Cod. Ruta"; rec."Cod. Ruta")
                {
                    Editable = false;
                }
                field("Nombre Ruta"; rec."Nombre Ruta")
                {
                    Editable = false;
                }
                field("Nombre Promotor"; rec."Nombre Promotor")
                {
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Actions")
            {
                Caption = '&Actions';
                action("&Update School List")
                {
                    Caption = '&Update School List';
                    Image = CalculateLines;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        FuncAPS: Codeunit "Funciones APS";
                    begin
                        if Promotor <> '' then
                            FuncAPS.LlenaPromotorColegios(Promotor)
                        else
                            FuncAPS.LlenaPromotorColegios(rec.GetRangeMin("Cod. Promotor"))
                    end;
                }
            }
        }
    }

    trigger OnOpenPage()
    begin
        if Promotor <> '' then
            rec.SetRange("Cod. Promotor", Promotor);
    end;

    trigger OnQueryClosePage(CloseAction: Action): Boolean
    begin
        if CloseAction = ACTION::OK then
            OKOnPush;
    end;

    var
        Col: Record "Promotor - Lista de Colegios";
        PromPlan: Record "Promotor - Planif. Visita";
        Promotor: Code[20];
        gAno: Integer;
        Sem: Integer;
        Seleccionar: Boolean;


    procedure RecibeParametros(CodPromotor: Code[20]; lAno: Integer; Semana: Integer)
    begin

        Promotor := CodPromotor;
        Sem := Semana;
        gAno := lAno;
    end;

    local procedure OKOnPush()
    begin

        Col.Reset;
        Col.SetRange("Cod. Promotor", rec."Cod. Promotor");
        Col.SetRange(Seleccionar, true);
        if Col.FindSet() then
            repeat
                PromPlan.Init;
                PromPlan.Validate("Cod. Promotor", Col."Cod. Promotor");
                PromPlan.Validate(Semana, Sem);
                PromPlan.Validate(Ano, gAno);
                PromPlan.Validate("Cod. Colegio", Col."Cod. Colegio");
                if PromPlan.Insert(true) then;

                Col.Seleccionar := false;
                Col.Modify;
            until Col.Next = 0;
    end;
}

