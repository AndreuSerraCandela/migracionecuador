#pragma implicitwith disable
page 76140 "Colegio - Nivel"
{
    ApplicationArea = all;
    DelayedInsert = true;
    PageType = Card;
    SourceTable = "Colegio - Nivel";

    layout
    {
        area(content)
        {
            repeater(Control1000000000)
            {
                ShowCaption = false;
                field("Cod. Colegio"; rec."Cod. Colegio")
                {
                    Visible = false;
                }
                field("Cod. Local"; rec."Cod. Local")
                {
                }
                field("Cod. Nivel"; rec."Cod. Nivel")
                {
                }
                field(Turno; rec.Turno)
                {
                }
                field("Categoria colegio"; rec."Categoria colegio")
                {
                }
                field(Ruta; rec.Ruta)
                {
                }
                field("Dto. Ticket Colegio"; rec."Dto. Ticket Colegio")
                {
                }
                field("Dto. Ticket Padres"; rec."Dto. Ticket Padres")
                {
                }
                field("Dto. Feria Colegio"; rec."Dto. Feria Colegio")
                {
                }
                field("Dto. Feria Padres"; rec."Dto. Feria Padres")
                {
                }
                field("Dto. Docente"; rec."Dto. Docente")
                {
                }
                field(Adoptado; rec.Adoptado)
                {
                }
                field("Estatus observado"; rec."Estatus observado")
                {
                }
                field(Correspondencia; rec.Correspondencia)
                {
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("&Level")
            {
                Caption = '&Level';
                action("&Adoption")
                {
                    Caption = '&Adoption';
                    Image = Edit;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    var
                        fAdopciones: Page "Colegio - Adopciones Cab";
                    begin
                        PromRuta.SetRange("Cod. Ruta", Rec.Ruta);
                        PromRuta.FindFirst;

                        fAdopciones.RecibeParametros(Rec."Cod. Colegio", Rec."Cod. Nivel", PromRuta."Cod. Promotor", Rec.Ruta, Rec.Turno);
                        fAdopciones.RunModal;

                        Clear(fAdopciones);
                    end;
                }
            }
        }
    }

    trigger OnInit()
    begin
        Rec."Cod. Colegio" := gColegio;
        Rec.City := gCity;
        Rec.County := gCounty;
        Rec."Post Code" := gPostCode;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        if Rec."Cod. Colegio" = '' then begin
            if gColegio = '' then
                Error(Err001, Rec.FieldCaption("Cod. Colegio"));
            Rec."Cod. Colegio" := gColegio;
        end;

        if Rec.City = '' then begin
            if gCity = '' then
                Error(Err001, Rec.FieldCaption(City));
            Rec.City := gCity;
        end;

        if Rec.County = '' then begin
            if gCounty = '' then
                Error(Err001, Rec.FieldCaption(County));
            Rec.County := gCounty;
        end;
        if Rec."Post Code" = '' then begin
            if gPostCode = '' then
                Error(Err001, Rec.FieldCaption("Post Code"));
            Rec."Post Code" := gPostCode;
        end;
    end;

    trigger OnOpenPage()
    begin
        if gColegio <> '' then
            Rec.SetRange("Cod. Colegio", gColegio);

        if gCity <> '' then
            Rec.SetRange(City, gCity);

        if gCounty <> '' then
            Rec.SetRange(County, gCounty);

        if gPostCode <> '' then
            Rec.SetRange("Post Code", gPostCode);
    end;

    var
        PromRuta: Record "Promotor - Rutas";
        gColegio: Code[30];
        gCity: Code[30];
        gCounty: Code[30];
        gPostCode: Code[30];
        Err001: Label 'You must specify a %1l to continue';


    procedure RecibeParametros(lColegio: Code[30]; lCity: Code[30]; lCounty: Code[30]; lPostCode: Code[30])
    begin
        gColegio := lColegio;
        gCity := lCity;
        gCounty := lCounty;
        gPostCode := lPostCode;
    end;
}

#pragma implicitwith restore

