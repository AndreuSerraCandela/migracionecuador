#pragma implicitwith disable
page 76206 "Estadistica Ranking Nivel"
{
    ApplicationArea = all;
    Editable = false;
    PageType = Card;
    SourceTable = "Estadistica Ranking Colegio";
    SourceTableTemporary = true;

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
                field("Grupo de Negocio"; rec."Grupo de Negocio")
                {
                }
                field("Cod. Nivel"; rec."Cod. Nivel")
                {
                }
                field("Categoria colegio"; rec."Categoria colegio")
                {
                }
                field(Porciento; rec.Porciento)
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
        Total := 0;

        ColAdopciones.Reset;
        ColAdopciones.SetRange("Cod. Colegio", Rec."Cod. Colegio");
        ColAdopciones.SetRange(Adopcion, 1, 2); //Mantener, Conquista
        if ColAdopciones.FindSet then
            repeat
                TarifVta.Reset;
                //TarifVta.SetRange("Item No.", ColAdopciones."Cod. Producto");
                TarifVta.SetRange("Asset Type", TarifVta."Asset Type"::Item);
                TarifVta.SetRange("Product No.", ColAdopciones."Cod. Producto");
                //TarifVta.SetRange("Sales Type", TarifVta."Sales Type"::"All Customers");
                TarifVta.SetRange("Source Type", TarifVta."Source Type"::"All Customers");
                TarifVta.SetRange("Ending Date", 0D);
                TarifVta.FindFirst;
                TarifVta.TestField("Unit Price");
                Total += TarifVta."Unit Price" * ColAdopciones."Cantidad Alumnos";
            until ColAdopciones.Next = 0;

        ColRankNiv.Reset;
        ColRankNiv.SetRange("Cod. Colegio", Rec."Cod. Colegio");
        if ColRankNiv.FindSet then
            repeat
                TotalGpoNivel := 0;

                Rec.Init;
                Rec."Cod. Colegio" := ColRankNiv."Cod. Colegio";
                Rec."Grupo de Negocio" := ColRankNiv."Grupo de Negocio";
                Rec."Cod. Nivel" := ColRankNiv."Cod. Nivel";
                Rec."Categoria colegio" := ColRankNiv."Categoria colegio";

                ColAdopciones.Reset;
                ColAdopciones.SetRange("Cod. Colegio", Rec."Cod. Colegio");
                ColAdopciones.SetRange(Adopcion, 1, 2); //Mantener, Conquista
                ColAdopciones.SetRange("Cod. Nivel", ColRankNiv."Cod. Nivel");
                ColAdopciones.SetRange("Grupo de Negocio", ColRankNiv."Grupo de Negocio");
                if ColAdopciones.FindSet then
                    repeat
                        TarifVta.Reset;
                        //TarifVta.SetRange("Item No.", ColAdopciones."Cod. Producto");
                        TarifVta.SetRange("Asset Type", TarifVta."Asset Type"::Item);
                        TarifVta.SetRange("Product No.", ColAdopciones."Cod. Producto");
                        //TarifVta.SetRange("Sales Type", TarifVta."Sales Type"::"All Customers");
                        TarifVta.SetRange("Source Type", TarifVta."Source Type"::"All Customers");
                        TarifVta.SetRange("Ending Date", 0D);
                        TarifVta.FindFirst;
                        TarifVta.TestField("Unit Price");
                        TotalGpoNivel += TarifVta."Unit Price" * ColAdopciones."Cantidad Alumnos";
                    until ColAdopciones.Next = 0;

                if (Total <> 0) and (TotalGpoNivel <> 0) then
                    Rec.Porciento := Round(TotalGpoNivel / Total, 0.01) * 100;
                //    MESSAGE('%1 %2 %3 %4',TotalGen,Total);
                Rec.Insert;
            until ColRankNiv.Next = 0;
    end;

    var
        Colegio: Record Contact;
        ColRankNiv: Record "Colegio - Ranking - Nivel";
        ColAdopciones: Record "Colegio - Adopciones Detalle";
        TarifVta: Record "Price List Line"; //"Sales Price";
        Porciento: Decimal;
        Total: Decimal;
        TotalGpoNivel: Decimal;
}

#pragma implicitwith restore

